import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'add_balance_states.dart';

class AddBalanceCubit extends Cubit<AddBalanceStates> {
  AddBalanceCubit() : super(AddBalanceInitState());

  static AddBalanceCubit get(context) => BlocProvider.of(context);


  final List<String> phoneNumbers = [
    '+1234567890',
    '+0987654321',
    '+1122334455'
  ];


  void makePhoneCall(String number) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: number,
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  void showPhoneNumbersDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.grey.withOpacity(0.5),
       barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title:   Text(context.tr(LocaleKeys.numbersConversionInfo)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: phoneNumbers.map((number) {
              return ListTile(
                title: Text(number),
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: number));
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                            content: Text(context.tr(LocaleKeys.numberCopied)),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone),
                      onPressed: () => makePhoneCall(number),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.mainColor),
              ),
              child:   Text(context.tr(LocaleKeys.back)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}