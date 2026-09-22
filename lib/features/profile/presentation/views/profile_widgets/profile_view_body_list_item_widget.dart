   import '../../../../../main_importants.dart';

//ignore: must_be_immutable
class ProfileViewBodyListItemWidget extends StatelessWidget {
  final String title;
  final String image;
  final bool svg;
  void Function() onTap;

  ProfileViewBodyListItemWidget(
      {super.key,
      required this.title,
      required this.onTap,
      required this.image, required this.svg,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:   EdgeInsets.symmetric(vertical: 10.h),
      child: Card(
        shadowColor: AppColors.mainColor,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: const Color(0xffF8F8F8),
          ),
          child: ListTile(
            onTap: onTap,
            leading:
            CustomNetWorkImage(imageUrl: image,height: 40.h,raduis: 5.r,width: 40.w,
            fit: BoxFit.cover,),
            title:Text(title,
                style: AppStyles.textStyle14W500White.copyWith(
                  color: AppColors.mainColor,
                )),
            trailing:   Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: AppColors.mainColor,
            ),
          ),
        ),
      ),
    );
  }
}
