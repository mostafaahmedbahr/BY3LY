import 'package:by3ly/core/shared_widgets/app_confirm_dialog.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/chat_models.dart';
import '../view_model/chat_cubit.dart';
import '../view_model/chat_states.dart';
import 'chat_helpers.dart';
import 'chat_widgets/chat_input_bar.dart';
import 'chat_widgets/chat_messages_list.dart';
import 'chat_widgets/image_source_sheet.dart';
import 'chat_widgets/message_action_sheet.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final cubit = ChatCubit.get(context);
    cubit.init();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return;

    final maxScrollExtent = position.maxScrollExtent;
    // When the messages fit on screen there is nothing older to reveal. Without
    // this guard the keyboard opening/closing triggers a load on every scroll
    // notification, which shows a repeated loading spinner.
    if (maxScrollExtent <= 0) return;

    // The list is reversed: the top (older messages) is maxScrollExtent.
    if (position.pixels < 20) return;
    if (position.pixels >= maxScrollExtent - 180) {
      ChatCubit.get(context).loadOlderMessages();
    }
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) return true;
    return _scrollController.position.pixels <= 90;
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendText() async {
    final cubit = ChatCubit.get(context);
    final text = _controller.text;
    final sent = await cubit.sendText(text);
    if (!mounted) return;
    if (sent) {
      // Only clear what was actually sent; text typed while the request was in
      // flight must stay in the field.
      if (_controller.text.trim() == text.trim()) {
        _controller.clear();
      }
      _scrollToBottom();
    }
  }

  Future<void> _pickAndSendImage() async {
    final source = await showImageSourceSheet(context);
    if (source == null || !mounted) return;

    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 88,
      maxWidth: 1600,
    );
    if (picked == null || !mounted) return;

    final sent = await ChatCubit.get(context).sendImage(picked.path);
    if (sent && mounted) _scrollToBottom();
  }

  Future<void> _deleteMessage(ChatMessageModel message) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.tr(LocaleKeys.deleteMessage),
      message: context.tr(LocaleKeys.deleteMessageConfirm),
      confirmText: context.tr(LocaleKeys.delete),
    );
    if (!confirmed || !mounted) return;
    ChatCubit.get(context).deleteMessage(message);
  }

  /// Shows a bottom sheet with actions for the long-pressed message.
  Future<void> _showMessageActions(ChatMessageModel message) async {
    await showMessageActionSheet(
      context: context,
      message: message,
      onCopy: () {
        Clipboard.setData(ClipboardData(text: message.body ?? ''))
            .then((_) {
          if (!mounted) return;
          Toast.showSuccessToast(
            msg: context.tr(LocaleKeys.copy),
            context: context,
          );
        });
      },
      onDelete: () => _deleteMessage(message),
    );
  }

  Future<void> _deleteConversation() async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.tr(LocaleKeys.deleteConversation),
      message: context.tr(LocaleKeys.deleteConversationConfirm),
      confirmText: context.tr(LocaleKeys.delete),
    );
    if (!confirmed || !mounted) return;
    ChatCubit.get(context).deleteConversation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {
        if (state is ChatMessageSendError) {
          Toast.showErrorToast(
            msg: chatErrorText(state.message),
            context: context,
          );
        } else if (state is ChatOlderMessagesError) {
          Toast.showErrorToast(
            msg: chatErrorText(state.message),
            context: context,
          );
        } else if (state is ChatMessageDeleteError) {
          Toast.showErrorToast(
            msg: chatErrorText(state.message),
            context: context,
          );
        } else if (state is ChatMessageDeleted) {
          Toast.showSuccessToast(
            msg: context.tr(LocaleKeys.messageDeleted),
            context: context,
          );
        } else if (state is ChatConversationDeleteError) {
          Toast.showErrorToast(
            msg: chatErrorText(state.message),
            context: context,
          );
        } else if (state is ChatConversationDeleted) {
          Toast.showSuccessToast(
            msg: context.tr(LocaleKeys.conversationDeleted),
            context: context,
          );
          Navigator.of(context).pop(true);
        } else if (state is ChatReceivingNewMessages) {
          if (_isNearBottom) _scrollToBottom();
        } else if (state is ChatMessageSent) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        final cubit = ChatCubit.get(context);
        final otherUser = cubit.conversation.otherUser;
        final product = cubit.conversation.product;
        final isDeletingConversation = state is ChatConversationDeleting;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            surfaceTintColor: AppColors.mainColor,
            shadowColor: AppColors.mainColor,
            bottom: isDeletingConversation
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(3),
                    child: LinearProgressIndicator(
                      minHeight: 3,
                      color: AppColors.accent,
                      backgroundColor: AppColors.border,
                    ),
                  )
                : null,
            titleSpacing: 0,
            title: Row(
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceVariant,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: CustomNetWorkImage(
                    imageUrl: otherUser?.image ?? '',
                    raduis: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        otherUser?.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      if (product?.name != null)
                        Text(
                          product!.name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              PopupMenuButton<String>(
                enabled: !isDeletingConversation,
                color: AppColors.surface,
                icon: Icon(Icons.more_vert_rounded, color: AppColors.text),
                onSelected: (_) => _deleteConversation(),
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: AppColors.redColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          context.tr(LocaleKeys.deleteConversation),
                          style: TextStyle(color: AppColors.text),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // if (product != null) ChatProductHeader(product: product),
              Expanded(
                child: ChatMessagesList(
                  scrollController: _scrollController,
                  onMessageLongPress: _showMessageActions,
                ),
              ),
              ChatInputBar(
                controller: _controller,
                onSend: _sendText,
                onAttach: _pickAndSendImage,
                isSending: cubit.isSending,
                isSendingImage: cubit.isSendingImage,
              ),
            ],
          ),
        );
      },
    );
  }
}

