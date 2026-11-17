import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shimmer/shimmer.dart';

import 'package:by3ly/features/chat/presentation/views/chat_helpers.dart';

import '../../view_model/help_support_chat_cubit.dart';
import '../../view_model/help_support_chat_states.dart';
import 'support_chat_input_bar.dart';
import 'support_message_bubble.dart';

/// Soft tinted chat background with a faint dot texture — warmer and richer
/// than a flat white scaffold, in both themes.
Color get _chatBackground =>
    AppColors.isDark ? AppColors.darkBackgroundColor : const Color(0xFFF3F7F4);

class HelpSupportChatViewBody extends StatelessWidget {
  const HelpSupportChatViewBody({
    super.key,
    required this.scrollController,
    required this.controller,
    required this.onAttach,
    required this.onSend,
  });

  final ScrollController scrollController;
  final TextEditingController controller;
  final VoidCallback onAttach;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelpSupportChatCubit, HelpSupportChatStates>(
      builder: (context, state) {
        final cubit = HelpSupportChatCubit.get(context);
        final messages = cubit.messages;

        Widget content;
        if ((state is SupportChatMessagesLoading ||
                state is HelpSupportChatInitState) &&
            messages.isEmpty) {
          content = const _SupportChatLoading();
        } else if (state is SupportChatMessagesError && messages.isEmpty) {
          content = CustomErrorWidget(
            error: chatErrorText(state.message),
            onTap: cubit.loadMessages,
          );
        } else if (messages.isEmpty) {
          content = const _SupportChatEmpty();
        } else {
          content = _MessagesList(scrollController: scrollController);
        }

        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          child: Container(
            decoration: BoxDecoration(
              color: _chatBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: CustomPaint(
              painter: _DotTexturePainter(),
              child: Column(
                children: [
                  Expanded(child: content),
                  SupportChatInputBar(
                    controller: controller,
                    onSend: onSend,
                    onAttach: onAttach,
                    isSending: cubit.isSending,
                    isSendingImage: cubit.isSendingImage,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DotTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (AppColors.isDark ? Colors.white : AppColors.mainColor)
          .withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    const spacing = 30.0;
    for (var y = spacing / 2; y < size.height; y += spacing) {
      for (var x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MessagesList extends StatelessWidget {
  const _MessagesList({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelpSupportChatCubit, HelpSupportChatStates>(
      builder: (context, state) {
        final cubit = HelpSupportChatCubit.get(context);
        final messages = cubit.messages;
        final showOlderLoader =
            state is SupportChatLoadingOlderMessages && cubit.isLoadingOlder;

        return ListView.builder(
          reverse: true,
          controller: scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
          itemCount: messages.length + (showOlderLoader ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= messages.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.2),
                  ),
                ),
              );
            }
            final message = messages[index];
            final imageUrl = supportImageUrl(message.image);
            return SupportMessageBubble(
              // Stable identity: prevents the reversed list from reusing a
              // bubble element for a different message when new ones arrive.
              key: ValueKey(message.id ?? 'index_$index'),
              message: message,
              onImageTap: message.isImage
                  ? () => showSupportImage(context, imageUrl)
                  : null,
            );
          },
        );
      },
    );
  }
}

/// Shimmer skeleton bubbles shown on the first load — more premium than a
/// bare spinner.
class _SupportChatLoading extends StatelessWidget {
  const _SupportChatLoading();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE7ECE8),
      highlightColor: isDark
          ? const Color(0xFF2C3A50)
          : const Color(0xFFFAFBFA),
      period: const Duration(milliseconds: 1500),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
        children: const [
          _SkeletonRow(widthFactor: 0.56, alignEnd: false),
          SizedBox(height: 10),
          _SkeletonRow(widthFactor: 0.42, alignEnd: true),
          SizedBox(height: 10),
          _SkeletonRow(widthFactor: 0.7, alignEnd: false),
          SizedBox(height: 10),
          _SkeletonRow(widthFactor: 0.35, alignEnd: true),
          SizedBox(height: 10),
          _SkeletonRow(widthFactor: 0.48, alignEnd: false),
        ],
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.widthFactor, required this.alignEnd});

  final double widthFactor;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignEnd
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        alignment: alignEnd
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

/// Hero empty state: gradient orb + glow + decorative rings.
class _SupportChatEmpty extends StatelessWidget {
  const _SupportChatEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer decorative rings
                  Container(
                    height: 148,
                    width: 148,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.14),
                      ),
                    ),
                  ),
                  Container(
                    height: 124,
                    width: 124,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  // Gradient orb with glow
                  Container(
                    height: 96,
                    width: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.secondColor, AppColors.mainColor],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mainColor.withValues(alpha: 0.45),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      size: 44,
                      color: Colors.white,
                    ),
                  ),
                  // Floating mini badge
                  PositionedDirectional(
                    end: 6,
                    bottom: 22,
                    child: Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.chat_bubble_rounded,
                        size: 16,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(
              context.tr(LocaleKeys.noMessagesYet),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.1,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr(LocaleKeys.startTheConversation),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
