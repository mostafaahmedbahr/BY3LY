import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

/// Floating, premium pill input bar for the support chat.
///
/// Frosted surface with a hairline border and soft shadow, a tinted
/// attach button and a gradient send button with a colored glow.
class SupportChatInputBar extends StatelessWidget {
  const SupportChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttach,
    required this.isSending,
    required this.isSendingImage,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final bool isSending;
  final bool isSendingImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.65),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _AttachButton(isSendingImage: isSendingImage, onTap: onAttach),
              const SizedBox(width: 4),
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 13.5, color: AppColors.text),
                  decoration: InputDecoration(
                    hintText: context.tr(LocaleKeys.writeYourProblemHere),
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                    ),
                    filled: true,
                    fillColor: AppColors.isDark
                        ? AppColors.surfaceVariant
                        : AppColors.grey2Color,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  final canSend = value.text.trim().isNotEmpty && !isSending;
                  return _SendButton(
                    isSending: isSending,
                    enabled: canSend,
                    onTap: canSend ? onSend : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachButton extends StatelessWidget {
  const _AttachButton({required this.isSendingImage, required this.onTap});

  final bool isSendingImage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.tr(LocaleKeys.attachImage),
      child: InkWell(
        onTap: isSendingImage ? null : onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.14),
            ),
          ),
          child: Center(
            child: isSendingImage
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.add_photo_alternate_outlined,
                    color: AppColors.accent,
                    size: 21,
                  ),
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.isSending,
    required this.enabled,
    required this.onTap,
  });

  final bool isSending;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.tr(LocaleKeys.send),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: enabled || isSending
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.secondColor, AppColors.mainColor],
                  )
                : null,
            color: enabled || isSending
                ? null
                : AppColors.isDark
                    ? AppColors.surfaceVariant
                    : AppColors.grey2Color,
            boxShadow: enabled && !isSending
                ? [
                    BoxShadow(
                      color: AppColors.mainColor.withValues(alpha: 0.45),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isSending
                ? const SizedBox(
                    height: 19,
                    width: 19,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    Icons.send_rounded,
                    size: 20,
                    color: enabled ? Colors.white : AppColors.textSecondary,
                  ),
          ),
        ),
      ),
    );
  }
}
