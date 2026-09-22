import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../confirmPayment/presentation/views/confirm_payment_view.dart';
import '../../view_model/add_balance_cubit.dart';

class AddBalanceViewBody extends StatelessWidget {
  const AddBalanceViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF8F8F8),
              ),
              child: ListTile(
                onTap: () {
                  AddBalanceCubit.get(context).showPhoneNumbersDialog(context);
                },
                title:   Text(
                  LocaleKeys.vodafoneCash.tr(),
                  style: AppStyles.textStyle16W500Black,
                ),
                subtitle: Text(LocaleKeys.now.tr(),
                    style: AppStyles.textStyle14W500White.copyWith(
                      color: AppColors.mainColor,
                    )),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.blackColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF8F8F8),
              ),
              child: ListTile(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: AppColors.whiteColor,
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              LocaleKeys.copyThis.tr(),
                              style: AppStyles.textStyle10W400Green
                                  .copyWith(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              subtitle:   Text(
                                  LocaleKeys.bankDes.tr()),
                              title:   Text(
                                LocaleKeys.bankName.tr(),
                                style: AppStyles.textStyle10W400Green,
                              ),
                              trailing: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () {
                                      Clipboard.setData(  ClipboardData(
                                          text:
                                          LocaleKeys.bankDes.tr()));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(
                                          content: Text(LocaleKeys.copyBankName.tr()),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              subtitle: const Text("123456789023"),
                              title:   Text(
                                LocaleKeys.accountNumber.tr(),
                                style: AppStyles.textStyle10W400Green,
                              ),
                              trailing: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () {
                                      Clipboard.setData(const ClipboardData(
                                          text: "123456789023"));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(
                                          content: Text(LocaleKeys.copyAccountNumber.tr()),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              subtitle:   Text(LocaleKeys.appName.tr()),
                              title:   Text(
                                LocaleKeys.companyName.tr(),
                                style: AppStyles.textStyle10W400Green,
                              ),
                              trailing: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () {
                                      Clipboard.setData(  ClipboardData(
                                          text: LocaleKeys.appName.tr()));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(
                                          content: Text(LocaleKeys.copyCompanyName.tr()),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                  );
                },
                title:   Text(
                  LocaleKeys.instaPay.tr(),
                  style: AppStyles.textStyle16W500Black,
                ),
                subtitle: Text( LocaleKeys.now.tr(),
                    style: AppStyles.textStyle14W500White.copyWith(
                      color: AppColors.mainColor,
                    )),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.blackColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40,),
          CustomButton(
            btnText: Text(
              LocaleKeys.confirmPayment.tr(),
              style:
                  AppStyles.textStyle16W600Black.copyWith(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const ConfirmPaymentView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
