import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> showReceiptSheet(BuildContext context, String url) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => ReceiptSheet(url: url),
  );
}

/// Premium bottom sheet receipt viewer with download + share actions.
class ReceiptSheet extends StatefulWidget {
  const ReceiptSheet({super.key, required this.url});

  final String url;

  @override
  State<ReceiptSheet> createState() => _ReceiptSheetState();
}

class _ReceiptSheetState extends State<ReceiptSheet> {
  bool _downloading = false;
  bool _sharing = false;

  Future<String?> _downloadToTemp() async {
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await Dio().download(widget.url, path);
    return path;
  }

  /// Save straight to the phone gallery.
  Future<void> _download() async {
    if (_downloading || _sharing) return;
    setState(() => _downloading = true);
    try {
      final path = await _downloadToTemp();
      if (!mounted || path == null) return;
      await Gal.putImage(path);
      if (!mounted) return;
      Toast.showSuccessToast(
        msg: context.tr(LocaleKeys.savedToGallery),
        context: context,
      );
    } catch (_) {
      if (!mounted) return;
      Toast.showErrorToast(
        msg: context.tr(LocaleKeys.receiptSaveFailed),
        context: context,
      );
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  Future<void> _share() async {
    if (_downloading || _sharing) return;
    setState(() => _sharing = true);
    try {
      final path = await _downloadToTemp();
      if (!mounted || path == null) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(path)],
          text: context.tr(LocaleKeys.receiptTitle),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      Toast.showErrorToast(
        msg: context.tr(LocaleKeys.receiptShareFailed),
        context: context,
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.62;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.tr(LocaleKeys.receiptTitle),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxH),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomNetWorkImage(
                  imageUrl: widget.url,
                  raduis: 16,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SheetAction(
                    icon: Icons.download_rounded,
                    label: context.tr(LocaleKeys.downloadReceipt),
                    busy: _downloading,
                    filled: true,
                    onTap: _download,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SheetAction(
                    icon: Icons.share_rounded,
                    label: context.tr(LocaleKeys.shareReceipt),
                    busy: _sharing,
                    filled: false,
                    onTap: _share,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.label,
    required this.busy,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool busy;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: busy ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: filled ? AppColors.mainColor : AppColors.surface,
          border: Border.all(
            color: filled ? AppColors.mainColor : AppColors.border,
          ),
        ),
        child: busy
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: filled ? Colors.white : AppColors.mainColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: filled ? Colors.white : AppColors.mainColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: filled ? Colors.white : AppColors.mainColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
