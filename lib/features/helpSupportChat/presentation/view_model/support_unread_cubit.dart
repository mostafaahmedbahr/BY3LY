import 'package:by3ly/core/extensions/log.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/support_chat_repository.dart';
import '../../../../core/app_services/local_services/cache_token.dart';
import '../../../../core/utils/guest_guard.dart';

/// Global, app-wide unread counter for support (staff) replies.
///
/// Registered once in GetIt and provided at the root of the widget tree.
/// Refreshed on app start, when the app returns to the foreground and after
/// any support-chat action that changes the number of unread messages.
class SupportUnreadCubit extends Cubit<SupportUnreadStates>
    with WidgetsBindingObserver {
  SupportUnreadCubit(this._repository) : super(SupportUnreadInitState()) {
    WidgetsBinding.instance.addObserver(this);
  }

  final SupportChatRepository _repository;

  int count = 0;
  bool _isFetching = false;

  static SupportUnreadCubit get(dynamic context) => BlocProvider.of(context);

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
          logWarning(
            'SupportUnreadCubit refresh failed: ${failure.errMessage}',
          );
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
    emit(SupportUnreadUpdated(count));
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}

abstract class SupportUnreadStates {}

class SupportUnreadInitState extends SupportUnreadStates {}

class SupportUnreadUpdated extends SupportUnreadStates {
  final int count;
  SupportUnreadUpdated(this.count);
}
