import 'package:by3ly/main_importants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/shared_widgets/custom_sized_box.dart';
import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../../../../core/utils/app_styles/app_styles.dart';

//ignore: must_be_immutable
class SettingsItemWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  void Function() onTap;

  SettingsItemWidget(
      {super.key,
      required this.title,
      required this.onTap,
      required this.subTitle,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: onTap,
        child: Card(
          shadowColor: AppColors.mainColor,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xffF8F8F8),
            ),
            child: Row(
              children: [
                image.contains("png") ?
                Image.asset(image,height: 20,) :
                SvgPicture.asset(image),
                Gap(18.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,
                        style: AppStyles.textStyle14W500White.copyWith(
                          color: AppColors.blackColor,
                        )),
                    Text(subTitle, style: AppStyles.textStyle10W400Gray),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.blackColor,
                ),
                const CustomSizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
