import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/chat_repository.dart';
import 'chat_states.dart';

/// Creates (or reopens) a conversation, then exposes it so the screen can
/// navigate to it. Kept separate from [ChatCubit] because it can be triggered
/// from the ad page or from a seller profile.
class StartChatCubit extends Cubit<StartChatStates> {
  StartChatCubit(this._repository) : super(StartChatInitState());

  final ChatRepository _repository;

  bool _isStarting = false;

  Future<void> start({int? productId, int? userId, String? body}) async {
    if (_isStarting) return;
    _isStarting = true;
    emit(StartChatLoading());

    final result = await _repository.createConversation(
      productId: productId,
      userId: userId,
      body: body,
    );

    if (isClosed) return;
    _isStarting = false;

    result.fold((failure) => emit(StartChatError(failure.errMessage)), (data) {
      final conversation = data.conversation;
      if (data.status == true && conversation != null) {
        emit(StartChatSuccess(conversation));
      } else {
        emit(StartChatError(data.message ?? 'Something went wrong'));
      }
    });
  }
}
