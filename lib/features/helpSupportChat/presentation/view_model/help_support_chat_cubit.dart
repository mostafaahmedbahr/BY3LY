import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'help_support_chat_states.dart';

class HelpSupportChatCubit extends Cubit<HelpSupportChatStates> {
  HelpSupportChatCubit() : super(HelpSupportChatInitState());

  static HelpSupportChatCubit get(context) => BlocProvider.of(context);


  final List<String> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();


  void sendMessage() {
    if (controller.text.isNotEmpty) {
        messages.insert(0, controller.text);
      //  messages.add(controller.text);
        controller.clear();
        emit(SendMessageSuccessState());
    }
    scrollToBottom();
  }


  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }


}