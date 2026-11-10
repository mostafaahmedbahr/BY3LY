import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'help_support_config.dart';
import 'help_support_states.dart';

class HelpSupportCubit extends Cubit<HelpSupportStates> {
  HelpSupportCubit() : super(HelpSupportInitState());

  static HelpSupportCubit get(BuildContext context) =>
      BlocProvider.of<HelpSupportCubit>(context);

  /// Opens the mail client with a prefilled subject. Returns false instead
  /// of throwing when no mail app is available so the UI can show a
  /// copy-to-clipboard fallback.
  Future<bool> sendEmail({String? subject}) {
    return _launch(HelpSupportConfig.buildMailtoUri(subject: subject));
  }

  /// Opens the dialer with the support line. Returns false on failure.
  Future<bool> makePhoneCall() => _launch(HelpSupportConfig.buildTelUri());

  Future<bool> _launch(Uri uri) async {
    try {
      if (!await canLaunchUrl(uri)) {
        debugPrint('HelpSupportCubit: cannot launch $uri');
        return false;
      }
      return await launchUrl(uri);
    } catch (e) {
      debugPrint('HelpSupportCubit: launch error for $uri — $e');
      return false;
    }
  }
}
