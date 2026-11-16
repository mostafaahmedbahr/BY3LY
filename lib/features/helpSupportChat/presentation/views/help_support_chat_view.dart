import 'package:by3ly/main_importants.dart';
import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';

import 'package:by3ly/features/helpSupportChat/presentation/view_model/help_support_chat_cubit.dart';
import 'package:by3ly/features/helpSupportChat/presentation/view_model/help_support_chat_states.dart';
import 'package:by3ly/features/chat/presentation/views/chat_helpers.dart';
import 'package:by3ly/features/chat/presentation/views/chat_widgets/image_source_sheet.dart';
import 'help_support_chat_widgets/help_support_chat_view_body.dart';

class HelpSupportChatView extends StatefulWidget {
  const HelpSupportChatView({super.key});

  @override
  State<HelpSupportChatView> createState() => _HelpSupportChatViewState();
}

class _HelpSupportChatViewState extends State<HelpSupportChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (GuestGuard.isGuest) {
      // Support replies are account-scoped; ask visitors to log in first.
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        final ok = await GuestGuard.requireLogin(context);
        if (!ok && mounted) Navigator.maybePop(context);
      });
      return;
    }
    HelpSupportChatCubit.get(context).init();
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
    // When the messages fit on screen there is nothing older to reveal.
    if (maxScrollExtent <= 0) return;

    // The list is reversed: the top (older messages) is maxScrollExtent.
    if (position.pixels >= maxScrollExtent - 180) {
      HelpSupportChatCubit.get(context).loadOlderMessages();
    }
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
    final cubit = HelpSupportChatCubit.get(context);
    final text = _controller.text;
    final sent = await cubit.sendText(text);
    if (!mounted) return;
    if (sent) {
      // Only clear what was actually sent; text typed while the request was
      // in flight must stay in the field.
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

    final sent = await HelpSupportChatCubit.get(context).sendImage(picked.path);
    if (sent && mounted) _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const _PremiumSupportAppBar(),
      body: BlocConsumer<HelpSupportChatCubit, HelpSupportChatStates>(
        listener: (context, state) {
          if (state is SupportChatMessageSendError) {
            Toast.showErrorToast(
              msg: chatErrorText(state.message),
              context: context,
            );
          } else if (state is SupportChatOlderMessagesError) {
            Toast.showErrorToast(
              msg: chatErrorText(state.message),
              context: context,
            );
          } else if (state is SupportChatReceivingNewMessages ||
              state is SupportChatMessageSent) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          return HelpSupportChatViewBody(
            scrollController: _scrollController,
            controller: _controller,
            onAttach: _pickAndSendImage,
            onSend: _sendText,
          );
        },
      ),
    );
  }
}

/// Gradient header with frosted-glass elements and decorative rings —
/// matches the premium language used across the app (add-ad, ad details).
class _PremiumSupportAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _PremiumSupportAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 64,
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: Stack(
        children: [
          // Signature gradient — dark navy to the brand greens.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.darkMainColor,
                  AppColors.mainColor,
                  AppColors.secondColor,
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
            child: SizedBox.expand(),
          ),
          // Decorative rings (non-interactive ornament).
          PositionedDirectional(
            top: -46,
            end: -30,
            child: _Ring(size: 122, color: Colors.white.withValues(alpha: 0.07)),
          ),
          PositionedDirectional(
            top: 14,
            end: 96,
            child: _Ring(size: 58, color: Colors.white.withValues(alpha: 0.06)),
          ),
          // Soft top light streak for depth.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.22),
            ),
          ),
        ],
      ),
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 12),
        child: Center(
          child: Material(
            color: Colors.white.withValues(alpha: 0.14),
            shape: const CircleBorder(
              side: BorderSide(color: Colors.white24, width: 1),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.maybePop(context),
              child: const SizedBox(
                height: 38,
                width: 38,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
            ),
          ),
        ),
      ),
      titleSpacing: 2,
      title: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(LocaleKeys.helpAndSupportChat),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 11,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      context.tr(LocaleKeys.supportSubtitle),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1.4),
        ),
      ),
    );
  }
}
