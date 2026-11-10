import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:by3ly/features/helpSupport/presentation/view-model/help_support_config.dart';
import 'package:by3ly/features/helpSupport/presentation/view-model/help_support_cubit.dart';
import 'package:by3ly/features/helpSupportChat/presentation/views/help_support_chat_view.dart';
import 'package:by3ly/features/reportProduct/presentation/views/report_the_product_view.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import 'common_questions_widget.dart';
import 'help_support_list_item_widget.dart';

class HelpSupportViewBody extends StatelessWidget {
  const HelpSupportViewBody({super.key});

  /// Copies the support contact to the clipboard and tells the user —
  /// used when neither a mail client nor a dialer is available.
  Future<void> _copyAndNotify(BuildContext context, String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } catch (_) {
      // Clipboard is best-effort.
    }
    if (!context.mounted) return;
    CherryToast.success(
      title: Text(
        context.tr(LocaleKeys.copiedToClipboard),
        style: const TextStyle(color: AppColors.mainColor),
      ),
    ).show(context);
  }

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: const HelpSupportChatView(),
      ),
    );
  }

  void _openReport(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: const ReportTheProductView(),
      ),
    );
  }

  Future<void> _openEmail(BuildContext context) async {
    final ok = await HelpSupportCubit.get(context).sendEmail(
      subject: context.tr(LocaleKeys.helpAndSupport),
    );
    if (!ok && context.mounted) {
      await _copyAndNotify(context, HelpSupportConfig.email);
    }
  }

  Future<void> _openCall(BuildContext context) async {
    final ok = await HelpSupportCubit.get(context).makePhoneCall();
    if (!ok && context.mounted) {
      await _copyAndNotify(context, HelpSupportConfig.phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          HelpSupportListItemWidget(
            icon: Icons.chat_bubble_rounded,
            iconColor: AppColors.secondColor,
            onTap: () => _openChat(context),
            title: context.tr(LocaleKeys.chat),
            subTitle: context.tr(LocaleKeys.speakWithUsDirectly),
          ),
          HelpSupportListItemWidget(
            icon: Icons.mail_rounded,
            iconColor: const Color(0xff2563EB),
            onTap: () => _openEmail(context),
            title: context.tr(LocaleKeys.email),
            subTitle: HelpSupportConfig.email,
          ),
          HelpSupportListItemWidget(
            icon: Icons.phone_rounded,
            iconColor: const Color(0xff16A34A),
            onTap: () => _openCall(context),
            title: context.tr(LocaleKeys.callUs),
            subTitle: HelpSupportConfig.phone,
          ),
          // HelpSupportListItemWidget(
          //   icon: Icons.flag_rounded,
          //   iconColor: AppColors.redColor,
          //   onTap: () => _openReport(context),
          //   title: context.tr(LocaleKeys.report),
          //   subTitle: context.tr(LocaleKeys.reportProduct),
          // ),
          const SizedBox(height: 16),
          const CommonQuestionsWidget(),
        ],
      ),
    );
  }
}
