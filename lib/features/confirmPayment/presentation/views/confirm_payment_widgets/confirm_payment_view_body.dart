import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/confirmPayment/presentation/view_model/confirm_payment_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/shared_widgets/custom_button.dart';
import '../../../../../core/shared_widgets/custom_sized_box.dart';
import '../../../../../core/utils/app_styles/app_styles.dart';
import '../../view_model/confirm_payment_cubit.dart';

class ConfirmPaymentViewBody extends StatelessWidget {
  const ConfirmPaymentViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConfirmPaymentCubit, ConfirmPaymentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: ConfirmPaymentCubit.get(context).image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              ConfirmPaymentCubit.get(context)
                                  .showPicker(context);
                            },
                            child: SvgPicture.asset(AppImages.camera),
                          ),
                          const CustomSizedBox(
                            height: 10,
                          ),
                            Text(
                            context.tr(LocaleKeys.sendReceiptPicture),
                            style: AppStyles.textStyle16W500Black,
                          ),
                        ],
                      )
                    : InkWell(
                        onTap: () {
                          ConfirmPaymentCubit.get(context).showPicker(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.mainColor, width: 2)),
                          child: Image.file(
                            ConfirmPaymentCubit.get(context).image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
              const CustomSizedBox(
                height: 10,
              ),
              CustomButton(
                btnText: Text(
                  LocaleKeys.send.tr(),
                  style: AppStyles.textStyle16W600Black
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
