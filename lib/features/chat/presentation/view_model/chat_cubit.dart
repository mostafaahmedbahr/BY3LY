import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/chat_models.dart';
import '../../data/repos/chat_repository.dart';
import 'chat_states.dart';
import 'chat_unread_cubit.dart';

class ChatCubit extends Cubit<ChatStates> with WidgetsBindingObserver {
  ChatCubit(this._repository, this._unreadCubit, {required this.conversation})
    : super(ChatInitState());

  final ChatRepository _repository;
  final ChatUnreadCubit _unreadCubit;

  static ChatCubit get(dynamic context) => BlocProvider.of(context);

  static const int _pageSize = 30;
  static const int _maxImageBytes = 5 * 1024 * 1024;

  ConversationModel conversation;

  /// Newest first (same order returned by the API). The list view is reversed
  /// so index 0 is rendered at the bottom.
  final List<ChatMessageModel> messages = [];

  bool isSending = false;
  bool isSendingImage = false;
  bool isLoadingOlder = false;
  bool _hasMoreOlder = true;
  bool get hasMoreOlder => _hasMoreOlder;

  bool _isFetchingMessages = false;
  bool _isPollingRequest = false;
  bool _isMarkingRead = false;
  bool _started = false;
  Timer? _pollTimer;

  Future<void> init() async {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    await loadMessages();
    _startPolling();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startPolling();
      poll();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _stopPolling();
    }
  }

  void _startPolling() {
    _stopPolling();
    _pollTimer = Timer.periodic(const Duration(minutes: 1), (_) => poll());
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  /// Loads the newest page of messages.
  ///
  /// [silent] is used by the polling loop: it must never show the full-screen
  /// loader or rebuild the list when nothing changed, otherwise an empty chat
  /// flashes a spinner every few seconds while the user is typing.
  Future<void> loadMessages({bool silent = false}) async {
    if (_isFetchingMessages) return;
    _isFetchingMessages = true;
    if (!silent && messages.isEmpty) emit(ChatMessagesLoading());

    final result = await _repository.getMessages(
      conversationId: conversation.id!,
      page: 1,
      perPage: _pageSize,
    );
    if (isClosed) return;
    _isFetchingMessages = false;

    result.fold(
      (failure) {
        if (!silent && messages.isEmpty) {
          emit(ChatMessagesError(failure.errMessage));
        } else {
          debugPrint('ChatCubit load failed: ${failure.errMessage}');
        }
      },
      (data) {
        if (data.status != true || data.data == null) {
          final message = data.message ?? 'Something went wrong';
          if (!silent && messages.isEmpty) {
            emit(ChatMessagesError(message));
          }
          return;
        }
        final loaded = _sortedDesc(data.data!.messages ?? const []);
        for (var m in loaded) {
          debugPrint('📥 LOADED MESSAGE: id=${m.id} type=${m.type} body=${m.body} image=${m.image} isMine=${m.isMine}');
        }
        final changed = !_sameIds(messages, loaded);
        messages
          ..clear()
          ..addAll(loaded);
        _updateHasMore(data.data!.pagination?.total);

        // Also replace a visible error screen once a silent retry succeeds.
        final shouldEmit = !silent || changed || state is ChatMessagesError;
        if (shouldEmit) emit(ChatMessagesSuccess(messages));
        // Opening the chat always marks it read and syncs the global badge.
        // On silent polls only do it when something new actually arrived.
        if (!silent || changed) markRead();
      },
    );
  }

  Future<void> loadOlderMessages() async {
    if (isLoadingOlder || !_hasMoreOlder || messages.isEmpty) return;
    final oldestId = messages.last.id;
    if (oldestId == null) return;

    isLoadingOlder = true;
    emit(ChatLoadingOlderMessages());

    final result = await _repository.getMessages(
      conversationId: conversation.id!,
      beforeId: oldestId,
      page: 1,
      perPage: _pageSize,
    );
    if (isClosed) return;
    isLoadingOlder = false;

    result.fold((failure) => emit(ChatOlderMessagesError(failure.errMessage)), (
      data,
    ) {
      if (data.status != true || data.data == null) {
        emit(ChatOlderMessagesError(data.message ?? 'Something went wrong'));
        return;
      }
      final older = _sortedDesc(data.data!.messages ?? const []);
      if (older.isEmpty) {
        _hasMoreOlder = false;
        emit(ChatMessagesSuccess(messages));
        return;
      }
      final existingIds = messages.map((e) => e.id).toSet();
      final newOnes = older
          .where((item) => item.id == null || !existingIds.contains(item.id))
          .toList();
      if (newOnes.isEmpty) {
        // The backend returned no older messages even though it reported more;
        // stop asking instead of polling the same page on every scroll.
        _hasMoreOlder = false;
        emit(ChatMessagesSuccess(messages));
        return;
      }
      messages
        ..addAll(newOnes)
        ..sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      _updateHasMore(data.data!.pagination?.total);
      emit(ChatMessagesSuccess(messages));
    });
  }

  Future<void> poll() async {
    if (!_started || _isPollingRequest || isClosed) return;
    // Never race a message the user is currently sending.
    if (isSending || isSendingImage) return;

    final newestId = messages.isEmpty ? null : messages.first.id;

    if (newestId == null) {
      // Nothing loaded yet (or an empty conversation): refresh silently so the
      // chat does not show a loading spinner every polling cycle.
      await loadMessages(silent: true);
      return;
    }

    _isPollingRequest = true;
    final result = await _repository.getMessages(
      conversationId: conversation.id!,
      afterId: newestId,
      page: 1,
      perPage: _pageSize,
    );
    if (isClosed) return;
    _isPollingRequest = false;

    result.fold(
      (failure) => debugPrint('ChatCubit poll failed: ${failure.errMessage}'),
      (data) {
        if (data.status != true || data.data == null) return;
        final incoming = _sortedDesc(
          data.data!.messages ?? const [],
        ).where((item) => !messages.any((m) => m.id == item.id)).toList();
        if (incoming.isEmpty) return;

        messages.insertAll(0, incoming);
        conversation = conversation.copyWith(
          lastMessage: incoming.first,
          updatedAt: incoming.first.createdAt,
        );
        emit(ChatReceivingNewMessages(incoming));
        final hasIncomingFromOther = incoming.any(
          (m) => m.isMine != true && m.isDeleted != true,
        );
        if (hasIncomingFromOther) markRead();
      },
    );
  }

  Future<void> markRead() async {
    if (_isMarkingRead || isClosed) return;
    _isMarkingRead = true;
    try {
      final result = await _repository.markConversationRead(
        conversationId: conversation.id!,
      );
      if (isClosed) return;
      result.fold(
        (failure) =>
            debugPrint('ChatCubit markRead failed: ${failure.errMessage}'),
        (data) {
          for (var i = 0; i < messages.length; i++) {
            if (messages[i].isRead != true) {
              messages[i] = messages[i].copyWith(isRead: true);
            }
          }
          conversation = conversation.copyWith(unreadCount: 0);
          if (data.unreadCount != null) {
            _unreadCubit.setCount(data.unreadCount!);
          }
          emit(ChatMarkedRead(_unreadCubit.count));
        },
      );
    } finally {
      _isMarkingRead = false;
    }
  }

  Future<bool> sendText(String text) async {
    final body = text.trim();
    if (body.isEmpty || isSending) return false;
    isSending = true;
    emit(ChatMessageSending());

    final result = await _repository.sendTextMessage(
      conversationId: conversation.id!,
      body: body,
    );
    if (isClosed) return false;
    isSending = false;

    return result.fold(
      (failure) {
        emit(ChatMessageSendError(failure.errMessage));
        return false;
      },
      (data) {
        final message = data.chatMessage;
        debugPrint('💬 SEND RESPONSE: status=${data.status} message=${data.message}');
        debugPrint('💬 PARSED MESSAGE: id=${message?.id} type=${message?.type} body=${message?.body} image=${message?.image} isMine=${message?.isMine}');
        if (data.status != true || message == null) {
          emit(ChatMessageSendError(data.message ?? 'Something went wrong'));
          return false;
        }
        _addSentMessage(message);
        emit(ChatMessageSent(message));
        return true;
      },
    );
  }

  Future<bool> sendImage(String imagePath) async {
    if (isSendingImage) return false;

    final extension = imagePath.split('.').last.toLowerCase();
    if (!{'jpg', 'jpeg', 'png', 'webp'}.contains(extension)) {
      emit(ChatMessageSendError('unsupportedImageType'));
      return false;
    }

    final file = File(imagePath);
    if (!await file.exists()) {
      emit(ChatMessageSendError('unexpectedError'));
      return false;
    }
    final size = await file.length();
    if (size > _maxImageBytes) {
      emit(ChatMessageSendError('imageTooLarge'));
      return false;
    }

    isSendingImage = true;
    emit(ChatImageSending());

    final result = await _repository.sendImageMessage(
      conversationId: conversation.id!,
      imagePath: imagePath,
    );
    if (isClosed) return false;
    isSendingImage = false;

    return result.fold(
      (failure) {
        emit(ChatMessageSendError(failure.errMessage));
        return false;
      },
      (data) {
        final message = data.chatMessage;
        debugPrint('💬 SEND RESPONSE: status=${data.status} message=${data.message}');
        debugPrint('💬 PARSED MESSAGE: id=${message?.id} type=${message?.type} body=${message?.body} image=${message?.image} isMine=${message?.isMine}');
        if (data.status != true || message == null) {
          emit(ChatMessageSendError(data.message ?? 'Something went wrong'));
          return false;
        }
        _addSentMessage(message);
        emit(ChatMessageSent(message));
        return true;
      },
    );
  }

  Future<void> deleteMessage(ChatMessageModel message) async {
    final messageId = message.id;
    if (messageId == null) return;
    emit(ChatMessageDeleting(messageId));

    final result = await _repository.deleteMessage(
      conversationId: conversation.id!,
      messageId: messageId,
    );
    if (isClosed) return;

    result.fold((failure) => emit(ChatMessageDeleteError(failure.errMessage)), (
      data,
    ) {
      if (data.status != true) {
        emit(ChatMessageDeleteError(data.message ?? 'Something went wrong'));
        return;
      }
      final deleted = data.chatMessage;
      final index = messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        messages[index] =
            deleted ??
            messages[index].copyWith(isDeleted: true, body: null, image: null);
        if (conversation.lastMessage?.id == messageId) {
          conversation = conversation.copyWith(lastMessage: messages[index]);
        }
      }
      emit(ChatMessageDeleted(messageId));
    });
  }

  Future<void> deleteConversation() async {
    emit(ChatConversationDeleting());
    final result = await _repository.deleteConversation(
      conversationId: conversation.id!,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(ChatConversationDeleteError(failure.errMessage)),
      (data) {
        if (data.status != true) {
          emit(
            ChatConversationDeleteError(data.message ?? 'Something went wrong'),
          );
          return;
        }
        if (data.unreadCount != null) {
          _unreadCubit.setCount(data.unreadCount!);
        }
        emit(ChatConversationDeleted());
      },
    );
  }

  void _addSentMessage(ChatMessageModel message) {
    if (message.id != null && messages.any((m) => m.id == message.id)) return;
    messages.insert(0, message);
    conversation = conversation.copyWith(
      lastMessage: message,
      updatedAt: message.createdAt,
    );
  }

  void _updateHasMore(int? total) {
    if (total == null) {
      _hasMoreOlder = messages.length >= _pageSize;
    } else {
      _hasMoreOlder = messages.length < total;
    }
  }

  List<ChatMessageModel> _sortedDesc(List<ChatMessageModel> items) {
    final copy = [...items];
    copy.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    return copy;
  }

  bool _sameIds(List<ChatMessageModel> a, List<ChatMessageModel> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  @override
  Future<void> close() async {
    _stopPolling();
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
