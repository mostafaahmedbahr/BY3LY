import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/chat_repository.dart';
import 'chat_states.dart';
import '../../../../core/app_services/local_services/cache_token.dart';
import '../../../../core/utils/guest_guard.dart';

/// Global, app-wide unread counter used by the chat badge.
///
/// It is registered once in GetIt and provided at the root of the widget tree.
/// The value is refreshed on app start, when the app returns to the foreground
/// and after any chat action that changes the number of unread messages.
class ChatUnreadCubit extends Cubit<ChatUnreadStates>
    with WidgetsBindingObserver {
  ChatUnreadCubit(this._repository) : super(ChatUnreadInitState()) {
    WidgetsBinding.instance.addObserver(this);
  }

  final ChatRepository _repository;

  int count = 0;
  bool _isFetching = false;

  static ChatUnreadCubit get(dynamic context) => BlocProvider.of(context);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refresh();
    }
  }

  Future<void> refresh() async {
    if (isClosed) return;
    // Guests have no token; the endpoint would 401 and could trigger the
    // global logout flow, so keep the badge at zero instead.
    if (GuestGuard.isGuest) {
      setCount(0);
      return;
    }
    if (_isFetching) return;
    _isFetching = true;
    try {
      // The token is checked outside the request too: after a logout the
      // app-wide cubit stays alive, so a lifecycle resume could otherwise
      // call this endpoint without a token and get a 401 (which triggers the
      // logout flow again).
      final token = await CacheTokenManger.getUserToken();
      if (isClosed) return;
      if (token == null || token.trim().isEmpty) {
        setCount(0);
        return;
      }

      final result = await _repository.getUnreadCount();
      if (isClosed) return;
      result.fold(
        (failure) {
          debugPrint('ChatUnreadCubit refresh failed: ${failure.errMessage}');
        },
        (data) {
          if (data.status == true) {
            setCount(data.unreadCount ?? 0);
          }
        },
      );
    } finally {
      _isFetching = false;
    }
  }

  void setCount(int value) {
    final safe = value < 0 ? 0 : value;
    if (safe == count) return;
    count = safe;
    emit(ChatUnreadUpdated(count));
  }

  void decrement([int amount = 1]) {
    setCount(count - amount);
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
