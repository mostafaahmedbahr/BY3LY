import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../views/add_balance_widgets/phone_numbers_dialog.dart';
import 'add_balance_config.dart';
import 'add_balance_states.dart';

class AddBalanceCubit extends Cubit<AddBalanceStates> {
  AddBalanceCubit() : super(AddBalanceInitState());

  static AddBalanceCubit get(BuildContext context) =>
      BlocProvider.of<AddBalanceCubit>(context);

  /// Support numbers — single source of truth in [AddBalanceConfig].
  List<String> get phoneNumbers => AddBalanceConfig.supportPhoneNumbers;

  /// Opens the OS dialer with [number] filled in.
  ///
  /// Fails softly: a SnackBar is shown instead of crashing the app.
  Future<void> makePhoneCall(String number, BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final errorMsg = context.tr(LocaleKeys.couldNotOpenPhone);
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    try {
      final canLaunch = await canLaunchUrl(phoneUri);
      if (canLaunch) {
        await launchUrl(phoneUri);
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(errorMsg)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(errorMsg)));
    }
  }

  /// Opens the support-numbers dialog (barrier-dismissible).
  ///
  /// Kept under the old name because it was called by the legacy UI.
  void showPhoneNumbersDialog(BuildContext context) =>
      PhoneNumbersDialog.show(context);
}
