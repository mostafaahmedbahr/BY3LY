import 'package:by3ly/main_importants.dart';

//ignore: must_be_immutable
class SettingsItemWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  void Function() onTap;

  SettingsItemWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.subTitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
              color: theme.cardColor,
            ),
            child: Row(
              children: [
                image.contains("png")
                    ? Image.asset(
                        image,
                        height: 20,
                        color:
                            isDark ? AppColors.whiteColor : AppColors.blackColor,
                        colorBlendMode: BlendMode.srcIn,
                      )
                    : SvgPicture.asset(
                        image,
                        colorFilter: ColorFilter.mode(
                          isDark ? AppColors.whiteColor : AppColors.blackColor,
                          BlendMode.srcIn,
                        ),
                      ),
                Gap(18.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppStyles.textStyle14W500White.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(subTitle, style: AppStyles.textStyle10W400Gray),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurface,
                ),
                const CustomSizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
