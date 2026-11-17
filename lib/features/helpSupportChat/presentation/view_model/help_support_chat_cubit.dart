import 'package:by3ly/core/extensions/log.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_services/local_services/cache_token.dart';
import '../../data/models/support_models.dart';
import '../../data/repos/support_chat_repository.dart';
import 'help_support_chat_states.dart';
import 'support_chat_rules.dart';
import 'support_unread_cubit.dart';

class HelpSupportChatCubit extends Cubit<HelpSupportChatStates>
    with WidgetsBindingObserver {
  HelpSupportChatCubit(this._repository, this._unreadCubit)
    : super(HelpSupportChatInitState());

  final SupportChatRepository _repository;
  final SupportUnreadCubit _unreadCubit;

  static HelpSupportChatCubit get(dynamic context) => BlocProvider.of(context);

  static const int _pageSize = 30;

  /// Token used for authenticated image streaming
  /// (`GET /api/support/messages/{id}/image`). Filled before the first
  /// message load in [init].
  String? authToken;

  /// Newest first (same order returned by the API). The list view is
  /// reversed, so index 0 is rendered at the bottom.
  final List<SupportMessageModel> messages = [];

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

  /// Called once when the support screen opens: resolves (or creates) the
  /// thread, loads the history and starts polling.
  Future<void> init() async {
    if (_started) {
      // Screen re-opened: refresh in the background, never blank the cache.
      _startPolling();
      await loadMessages(silent: true);
      return;
    }
    _started = true;
    // Show the loading skeleton on the very first frame — before any async
    // work — so the screen never flashes the empty state while the first
    // network calls are in flight.
    emit(SupportChatMessagesLoading());
    WidgetsBinding.instance.addObserver(this);

    // Warm the token used for authenticated image URLs without blocking
    // the conversation round-trip.
    final tokenFuture = CacheTokenManger.getUserToken();

    // Opening the screen creates the support thread on first open.
    final conversation = await _repository.getConversation();
    if (isClosed) return;
    conversation.fold(
      (failure) => logWarning(
        'HelpSupportChatCubit conversation failed: ${failure.errMessage}',
      ),
      (data) {
        logWarning(
          'HelpSupportChatCubit conversation ready: id=${data.conversationId}',
        );
      },
    );

    authToken = await tokenFuture;
    if (isClosed) return;

    await loadMessages();
    if (isClosed) return;
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
  /// loader or rebuild the list when nothing changed.
  Future<void> loadMessages({bool silent = false}) async {
    if (_isFetchingMessages) return;
    _isFetchingMessages = true;
    if (!silent && messages.isEmpty) emit(SupportChatMessagesLoading());

    final result = await _repository.getMessages(page: 1, perPage: _pageSize);
    if (isClosed) return;
    _isFetchingMessages = false;

    result.fold(
      (failure) {
        if (!silent && messages.isEmpty) {
          emit(SupportChatMessagesError(failure.errMessage));
        } else {
          logWarning('HelpSupportChatCubit load failed: ${failure.errMessage}');
        }
      },
      (data) {
        if (data.status != true) {
          final message = data.message ?? 'Something went wrong';
          if (!silent && messages.isEmpty) {
            emit(SupportChatMessagesError(message));
          }
          return;
        }
        final loaded = SupportChatRules.sortedMessagesDesc(
          data.messages ?? const [],
        );
        final changed = !SupportChatRules.sameMessageIds(messages, loaded);
        messages
          ..clear()
          ..addAll(loaded);
        _updateHasMore(data.pagination?.total);

        final shouldEmit =
            !silent || changed || state is SupportChatMessagesError;
        if (shouldEmit) emit(SupportChatMessagesSuccess());
        // Opening the chat marks staff replies as read; on silent polls only
        // do it when something new actually arrived.
        if (!silent || changed) markRead();
      },
    );
  }

  Future<void> loadOlderMessages() async {
    if (isLoadingOlder || !_hasMoreOlder || messages.isEmpty) return;
    final oldestId = messages.last.id;
    if (oldestId == null) return;

    isLoadingOlder = true;
    emit(SupportChatLoadingOlderMessages());

    final result = await _repository.getMessages(
      beforeId: oldestId,
      page: 1,
      perPage: _pageSize,
    );
    if (isClosed) return;
    isLoadingOlder = false;

    result.fold(
      (failure) => emit(SupportChatOlderMessagesError(failure.errMessage)),
      (data) {
        if (data.status != true) {
          emit(
            SupportChatOlderMessagesError(
              data.message ?? 'Something went wrong',
            ),
          );
          return;
        }
        final older = SupportChatRules.sortedMessagesDesc(
          data.messages ?? const [],
        );
        if (older.isEmpty) {
          _hasMoreOlder = false;
          emit(SupportChatMessagesSuccess());
          return;
        }
        final newOnes = SupportChatRules.filterNewMessages(older, messages);
        if (newOnes.isEmpty) {
          // The backend reported more history but returned none; stop asking
          // instead of re-fetching the same page on every scroll.
          _hasMoreOlder = false;
          emit(SupportChatMessagesSuccess());
          return;
        }
        messages
          ..addAll(newOnes)
          ..sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
        _updateHasMore(data.pagination?.total);
        emit(SupportChatMessagesSuccess());
      },
    );
  }

  Future<void> poll() async {
    if (!_started || _isPollingRequest || isClosed) return;
    // Never race a message the user is currently sending.
    if (isSending || isSendingImage) return;

    final newestId = messages.isEmpty ? null : messages.first.id;

    if (newestId == null) {
      // Nothing loaded yet (or an empty thread): refresh silently.
      await loadMessages(silent: true);
      return;
    }

    _isPollingRequest = true;
    final result = await _repository.getMessages(
      afterId: newestId,
      page: 1,
      perPage: _pageSize,
    );
    if (isClosed) return;
    _isPollingRequest = false;

    result.fold(
      (failure) =>
          logWarning('HelpSupportChatCubit poll failed: ${failure.errMessage}'),
      (data) {
        if (data.status != true) return;
        final incoming = SupportChatRules.filterNewMessages(
          SupportChatRules.sortedMessagesDesc(data.messages ?? const []),
          messages,
        );
        if (incoming.isEmpty) return;

        messages.insertAll(0, incoming);
        emit(SupportChatReceivingNewMessages());
        final hasIncomingFromSupport = incoming.any(
          (m) => m.fromSupport && m.isDeleted != true,
        );
        if (hasIncomingFromSupport) markRead();
      },
    );
  }

  Future<void> markRead() async {
    if (_isMarkingRead || isClosed) return;
    _isMarkingRead = true;
    try {
      final result = await _repository.markRead();
      if (isClosed) return;
      result.fold(
        (failure) => logWarning(
          'HelpSupportChatCubit markRead failed: ${failure.errMessage}',
        ),
        (data) {
          final updated = SupportChatRules.markAllMessagesRead(messages);
          messages
            ..clear()
            ..addAll(updated);
          if (data.unreadCount != null) {
            _unreadCubit.setCount(data.unreadCount!);
          } else {
            _unreadCubit.setCount(0);
          }
          emit(SupportChatMarkedRead());
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
    emit(SupportChatMessageSending());

    final result = await _repository.sendTextMessage(body: body);
    if (isClosed) return false;
    isSending = false;

    return result.fold(
      (failure) {
        emit(SupportChatMessageSendError(failure.errMessage));
        return false;
      },
      (data) {
        final message = data.supportMessage;
        if (data.status != true || message == null) {
          emit(
            SupportChatMessageSendError(data.message ?? 'Something went wrong'),
          );
          return false;
        }
        _addSentMessage(message);
        emit(SupportChatMessageSent());
        return true;
      },
    );
  }

  Future<bool> sendImage(String imagePath) async {
    if (isSendingImage) return false;

    if (!SupportChatRules.isAllowedImageExtension(imagePath)) {
      emit(SupportChatMessageSendError('unsupportedImageType'));
      return false;
    }

    if (!await SupportChatRules.validateImageFile(imagePath)) {
      emit(SupportChatMessageSendError('imageTooLarge'));
      return false;
    }

    isSendingImage = true;
    emit(SupportChatImageSending());

    final result = await _repository.sendImageMessage(imagePath: imagePath);
    if (isClosed) return false;
    isSendingImage = false;

    return result.fold(
      (failure) {
        emit(SupportChatMessageSendError(failure.errMessage));
        return false;
      },
      (data) {
        final message = data.supportMessage;
        if (data.status != true || message == null) {
          emit(
            SupportChatMessageSendError(data.message ?? 'Something went wrong'),
          );
          return false;
        }
        _addSentMessage(message);
        emit(SupportChatMessageSent());
        return true;
      },
    );
  }

  void _addSentMessage(SupportMessageModel message) {
    if (message.id != null && messages.any((m) => m.id == message.id)) return;
    messages.insert(0, message);
  }

  void _updateHasMore(int? total) {
    _hasMoreOlder = SupportChatRules.hasMoreOlder(messages, total, _pageSize);
  }

  @override
  Future<void> close() async {
    _stopPolling();
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
