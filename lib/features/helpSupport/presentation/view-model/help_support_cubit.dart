import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'help_support_states.dart';

class HelpSupportCubit extends Cubit<HelpSupportStates> {
  HelpSupportCubit() : super(HelpSupportInitState());

  static HelpSupportCubit get(context) => BlocProvider.of(context);


  void launchURL() async {
    final Uri url = Uri.parse('https://www.example.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'mustafa.bahr12323@gmail.com',
      query: {
        'subject': 'Example Subject',
        'body': 'Hello, this is an example email.'
      }.entries.map((entry) => '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}').join('&'),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }


  void makePhoneCall() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+1234567890', // ضع هنا رقم الهاتف الذي تريد الاتصال به
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

}