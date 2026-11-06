
import '../../../../../main_importants.dart';

//ignore: must_be_immutable
class ProfileViewBodyListItemWidget extends StatelessWidget {
  final String title;
  final String image;
  final String? subtitle;
  final bool svg;
  final VoidCallback onTap;

  const ProfileViewBodyListItemWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.image,
    required this.svg,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                // Category Image
                Hero(
                  tag: 'category_$image',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: SizedBox(
                      height: 78.h,
                      width: 82.w,
                      child: CustomNetWorkImage(
                        imageUrl: image,
                        height: 78.h,
                        width: 82.w,
                        raduis: 15.r,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 14.w),

                // Category Information
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

                      SizedBox(height: 9.h),

                      if (subtitle != null)
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
                  ),
                ),

                SizedBox(width: 8.w),

                // Arrow
                Container(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
