
import '../../../../../main_importants.dart';

enum ProfileItemStyle {
  premium,
  classic,
}

class ProfileViewBodyListItemWidget extends StatelessWidget {
  final String title;
  final String? image;
  final String? subtitle;
  final IconData? icon;
  final bool svg;
  final VoidCallback onTap;
  final ProfileItemStyle style;

  const ProfileViewBodyListItemWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.image,
    this.subtitle,
    this.icon,
    this.svg = false,
    this.style = ProfileItemStyle.premium,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case ProfileItemStyle.premium:
        return _buildPremiumItem(context);

      case ProfileItemStyle.classic:
        return _buildClassicItem(context);
    }
  }

  // ================= PREMIUM DESIGN =================

  Widget _buildPremiumItem(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          height: 105.h,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.mainColor.withValues(alpha: 0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.045),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                _buildLeading(
                  context,
                  width: 82.w,
                  height: 78.h,
                  radius: 15.r,
                ),

                SizedBox(width: 16.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),

                      if (subtitle != null) ...[
                        SizedBox(height: 9.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor.withValues(
                              alpha: 0.09,
                            ),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.grid_view_rounded,
                                color: AppColors.mainColor,
                                size: 13.sp,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                subtitle!,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                _buildArrow(circle: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= CLASSIC DESIGN =================

  Widget _buildClassicItem(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Material(
        color: Theme.of(context).cardColor,
        elevation: 2,
        shadowColor: AppColors.mainColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: SizedBox(
            height: 65.h,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                children: [
                  // مساحة ثابتة لكل الأيقونات
                  SizedBox(
                    width: 38.w,
                    child: Center(
                      child: _buildLeading(
                        context,
                        width: 30.w,
                        height: 30.h,
                        radius: 8.r,
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // العنوان
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.textStyle14W500White.copyWith(
                        color: isDark
                            ? AppColors.whiteColor
                            : AppColors.blackColor,
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // السهم
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15.sp,
                    color: isDark
                        ? AppColors.whiteColor.withValues(alpha: 0.7)
                        : AppColors.blackColor.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= IMAGE OR ICON =================

  Widget _buildLeading(
      BuildContext context, {
        required double width,
        required double height,
        required double radius,
      }) {
    final hasImage = image != null && image!.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: hasImage
            ? Hero(
          tag: 'category_$image',
          child: CustomNetWorkImage(
            imageUrl: image!,
            height: height,
            width: width,
            raduis: radius,
            fit: BoxFit.cover,
          ),
        )
            : Container(
          color: AppColors.mainColor.withValues(alpha: 0.09),
          alignment: Alignment.center,
          child: Icon(
            icon ?? Icons.category_rounded,
            size: style == ProfileItemStyle.premium
                ? 34.sp
                : 22.sp,
            color: isDark ? AppColors.whiteColor : AppColors.mainColor,
          ),
        ),
      ),
    );
  }

  // ================= ARROW =================

  Widget _buildArrow({bool circle = false}) {
    if (!circle) {
      return Icon(
        Icons.arrow_forward_ios_rounded,
        color: AppColors.mainColor,
        size: 16.sp,
      );
    }

    return Container(
      height: 34.r,
      width: 34.r,
      decoration: BoxDecoration(
        color: AppColors.mainColor.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        color: AppColors.mainColor,
        size: 14.sp,
      ),
    );
  }
}
