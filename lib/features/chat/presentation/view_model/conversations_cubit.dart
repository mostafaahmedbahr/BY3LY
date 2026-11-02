import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/chat_models.dart';
import '../../data/repos/chat_repository.dart';
import 'chat_states.dart';
import 'chat_unread_cubit.dart';

class ConversationsCubit extends Cubit<ConversationsStates>
    with WidgetsBindingObserver {
  ConversationsCubit(this._repository, this._unreadCubit)
    : super(ConversationsInitState()) {
    WidgetsBinding.instance.addObserver(this);
  }

  final ChatRepository _repository;
  final ChatUnreadCubit _unreadCubit;

  static ConversationsCubit get(dynamic context) => BlocProvider.of(context);

  final List<ConversationModel> conversations = [];

  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool get hasMore => currentPage < lastPage;

  bool _isFetching = false;
  bool _pollingSuspended = false;
  Timer? _pollTimer;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_pollingSuspended) return;
      startPolling();
      refresh();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _stopTimer();
    }
  }

  void startPolling() {
    _pollingSuspended = false;
    _stopTimer();
    // The list is only a preview: poll it so a new message from the other side
    // appears without a manual refresh.
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      refresh(silent: true);
    });
  }

  /// Stops background polling while the user is inside a chat screen.
  void stopPolling() {
    _pollingSuspended = true;
    _stopTimer();
  }

  void _stopTimer() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> getConversations({
    bool loadMore = false,
    bool silent = false,
  }) async {
    if (_isFetching) return;
    if (loadMore && !hasMore) return;
    _isFetching = true;

    final page = loadMore ? currentPage + 1 : 1;
    if (loadMore) {
      isLoadingMore = true;
      emit(ConversationsPaginating());
    } else if (!silent || conversations.isEmpty) {
      emit(ConversationsLoading());
    } else {
      emit(ConversationsRefreshing());
    }

    final result = await _repository.getConversations(page: page, perPage: 15);

    if (isClosed) return;
    _isFetching = false;
    isLoadingMore = false;

    result.fold(
      (failure) {
        if (loadMore) {
          emit(ConversationsPaginationError(failure.errMessage));
        } else if (conversations.isEmpty) {
          emit(ConversationsError(failure.errMessage));
        } else {
          debugPrint(
            'ConversationsCubit refresh failed: ${failure.errMessage}',
          );
        }
      },
      (data) {
        if (data.status != true || data.data == null) {
          final message = data.message ?? 'Something went wrong';
          if (loadMore) {
            emit(ConversationsPaginationError(message));
          } else if (conversations.isEmpty) {
            emit(ConversationsError(message));
          }
          return;
        }

        final items = data.data!.conversations ?? [];
        final pagination = data.data!.pagination;
        currentPage = pagination?.currentPage ?? page;
        lastPage =
            pagination?.lastPage ?? pagination?.totalPages ?? currentPage;

        if (loadMore) {
          final existingIds = conversations.map((e) => e.id).toSet();
          conversations.addAll(
            items.where((item) => !existingIds.contains(item.id)),
          );
        } else {
          conversations
            ..clear()
            ..addAll(items);
        }

        final totalUnread =
            data.data!.unreadCount ??
            conversations.fold<int>(
              0,
              (sum, item) => sum + (item.unreadCount ?? 0),
            );
        _unreadCubit.setCount(totalUnread);

        emit(ConversationsSuccess(data));
      },
    );
  }

  Future<void> refresh({bool silent = false}) =>
      getConversations(silent: silent);

  Future<void> loadMore() => getConversations(loadMore: true);

  /// Zeroes the badge of one conversation as soon as it is opened.
  void markConversationReadLocally(int? conversationId) {
    if (conversationId == null) return;
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index == -1) return;
    final unread = conversations[index].unreadCount ?? 0;
    if (unread > 0) {
      conversations[index] = conversations[index].copyWith(unreadCount: 0);
      _unreadCubit.decrement(unread);
      emit(ConversationReadUpdated(conversationId));
    }
  }

  Future<void> deleteConversation(int? conversationId) async {
    if (conversationId == null) return;
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index == -1) return;

    final removed = conversations.removeAt(index);
    final removedUnread = removed.unreadCount ?? 0;
    if (removedUnread > 0) _unreadCubit.decrement(removedUnread);
    emit(ConversationDeleted(conversationId));

    final result = await _repository.deleteConversation(
      conversationId: conversationId,
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        conversations.insert(index, removed);
        if (removedUnread > 0) {
          _unreadCubit.setCount(_unreadCubit.count + removedUnread);
        }
        emit(ConversationDeleteError(failure.errMessage));
      },
      (data) {
        if (data.unreadCount != null) {
          _unreadCubit.setCount(data.unreadCount!);
        }
      },
    );
  }

  @override
  Future<void> close() async {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
