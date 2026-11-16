import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:by3ly/main_importants.dart';
import 'package:by3ly/core/utils/app_consts/storage_keys.dart';
import 'package:by3ly/features/helpSupportChat/data/models/support_models.dart';
import 'package:by3ly/features/chat/presentation/views/chat_helpers.dart';

/// Resolves a possibly-relative image URL returned by the API to an
/// absolute one. The API returns paths such as `/api/support/messages/12/image`.
String supportImageUrl(String? raw) {
  if (raw == null) return '';
  final value = raw.trim();
  if (value.isEmpty) return '';
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return value;
  }
  final base = Uri.parse(EndPoints.baseUrl);
  if (value.startsWith('/')) {
    // Host-absolute path (carries the /api prefix itself).
    return '${base.scheme}://${base.authority}$value';
  }
  final cleanBase = EndPoints.baseUrl.endsWith('/')
      ? EndPoints.baseUrl
      : '${EndPoints.baseUrl}/';
  return '$cleanBase$value';
}

/// Support image streaming requires the same bearer token as the rest of the
/// API, so the headers must be passed explicitly to the image loader.
Map<String, String> supportImageHeaders() {
  final savedLang = CacheHelper.getData(key: StorageKeys.language);
  final langCode = (savedLang is String && savedLang.isNotEmpty)
      ? savedLang
      : 'ar';
  final headers = <String, String>{'Accept': 'application/json', 'lang': langCode};
  // The support cubit awaits getUserToken() in init() before the first
  // render, so the static is populated at this point on this screen.
  final token = CacheTokenManger.userToken;
  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }
  return headers;
}

/// Full-screen image viewer for support attachments (auth-required URLs).
void showSupportImage(BuildContext context, String imageUrl) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => Navigator.pop(dialogContext),
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 4,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            httpHeaders: supportImageHeaders(),
            fit: BoxFit.contain,
            placeholder: (_, _) => const CustomLoading(),
            errorWidget: (_, _, _) =>
                const Icon(Icons.broken_image_outlined, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}

class SupportMessageBubble extends StatelessWidget {
  const SupportMessageBubble({
    super.key,
    required this.message,
    required this.onImageTap,
  });

  final SupportMessageModel message;
  final VoidCallback? onImageTap;

  bool get _isDeleted => message.isDeleted == true;

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine == true || !message.fromSupport;
    final textColor = isMine ? Colors.white : AppColors.text;

    final decoration = isMine
        ? BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              topStart: const Radius.circular(18),
              topEnd: const Radius.circular(18),
              bottomStart: const Radius.circular(18),
              bottomEnd: const Radius.circular(4),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.secondColor, AppColors.mainColor],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.mainColor.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          )
        : BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadiusDirectional.only(
              topStart: const Radius.circular(18),
              topEnd: const Radius.circular(18),
              bottomStart: const Radius.circular(4),
              bottomEnd: const Radius.circular(18),
            ),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.045),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          );

    return Align(
      alignment: isMine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        margin: const EdgeInsets.symmetric(vertical: 3.5),
        padding: EdgeInsets.all(message.isImage && !_isDeleted ? 5 : 12),
        decoration: decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isMine && !_isDeleted)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2.5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.headset_mic_rounded,
                        size: 10,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.tr(LocaleKeys.supportTeam),
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                          color: AppColors.mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_isDeleted)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.block_rounded,
                      size: 15,
                      color: AppColors.redColor.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.tr(LocaleKeys.deletedMessage),
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.redColor.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              if (message.isImage)
                GestureDetector(
                  onTap: onImageTap,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 220,
                      height: 180,
                      child: CachedNetworkImage(
                        imageUrl: supportImageUrl(message.image),
                        httpHeaders: supportImageHeaders(),
                        fit: BoxFit.cover,
                        placeholder: (_, _) =>
                            const Center(child: CustomLoading()),
                        errorWidget: (_, _, _) =>
                            const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),
                ),
              if ((message.body?.trim().isNotEmpty ?? false))
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Text(
                    message.body!,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.45,
                      color: textColor,
                    ),
                  ),
                ),
            ],
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 2,
                end: 2,
                top: 4,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatMessageTimestamp(message.createdAt),
                    style: TextStyle(
                      fontSize: 9.5,
                      color: textColor.withValues(alpha: 0.75),
                    ),
                  ),
                  if (isMine && !_isDeleted) ...[
                    const SizedBox(width: 4),
                    Icon(
                      message.isRead == true
                          ? Icons.done_all_rounded
                          : Icons.done_rounded,
                      size: 13,
                      color: message.isRead == true
                          ? const Color(0xFF9BF5C9)
                          : textColor.withValues(alpha: 0.75),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 280.ms, curve: Curves.easeOut)
        .slideY(begin: 0.1, end: 0, duration: 280.ms, curve: Curves.easeOutCubic);
  }
}
