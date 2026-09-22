import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../main_importants.dart';
import '../../view_model/choose_location_cubit.dart';
import '../../view_model/choose_location_states.dart';

class ChooseCenter extends StatelessWidget {
  const ChooseCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseLocationCubit, ChooseLocationStates>(
      builder: (context, state) {
        var chooseLocationCubit = ChooseLocationCubit.get(context);
        Locale locale = EasyLocalization.of(context)!.locale;

        return Column(
          children: [
            Align(
              alignment: locale.languageCode == 'ar'
                  ? Alignment.topRight
                  : Alignment.topLeft,
              child: Text(
                context.tr(LocaleKeys.center),
                style: AppStyles.textStyle16W500Black,
              ),
            ),
            const SizedBox(height: 20),
            chooseLocationCubit.centerIsSelect
                ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(14, 133, 101, 0.25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(AppImages.mapLocation),
                      const SizedBox(width: 10),
                      Text(
                        chooseLocationCubit.selectedCenter,
                        style: AppStyles.textStyle16W600Black.copyWith(
                          color: AppColors.mainColor,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      chooseLocationCubit.resetCenterSelection();
                    },
                    child: Row(
                      children: [
                        Text(
                          context.tr(LocaleKeys.change),
                          style: AppStyles.textStyle16W500Black.copyWith(
                            color: AppColors.blackColor,
                          ),
                        ),
                        const SizedBox(width: 5),
                        SvgPicture.asset(
                          AppImages.globe,
                          colorFilter: const ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chooseLocationCubit.allCentersList.length,
              itemBuilder: (context, index) {
                final center = chooseLocationCubit.allCentersList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      chooseLocationCubit.chooseCenter(
                        center.name!,
                        center.id!,
                      );
                    },
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: chooseLocationCubit.selectedCenter ==
                            center.name
                            ? const Color.fromRGBO(14, 133, 101, 0.25)
                            : const Color(0xffF8F8F8),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppImages.mapLocation),
                          const SizedBox(width: 10),
                          Text(
                            center.name.toString(),
                            style: AppStyles.textStyle16W600Black
                                .copyWith(
                                color: AppColors.mainColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
