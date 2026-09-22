import 'package:by3ly/features/register/presentation/view_model/register_cubit.dart';
import 'package:by3ly/features/register/presentation/view_model/register_states.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../main_importants.dart';

class AppBarWithUploadImage extends StatelessWidget {
  const AppBarWithUploadImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterStates>(
      buildWhen: (previous, current) {
        return current is UploadImageSuccessState ||
            current is UploadImageErrorState ||
            current is ClearDataSuccess ||
            current is ClearImageSuccessState;
      },

      builder: (BuildContext context, state) {
        var registerCubit = RegisterCubit.get(context);
        return SizedBox(
          height: 230.h,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset(
                AppImages.appBarImage,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      context.tr(LocaleKeys.register),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    /// for just take the same space
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),

              /// image
              Positioned(
                bottom: 0,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    registerCubit.profileImage != null &&
                            registerCubit.profileImage!.path != ""
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.r)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.r),
                              child: Image.file(
                                registerCubit.profileImage!,
                                fit: BoxFit.cover,
                                height: 120.h,
                                width: 120.w,
                              ),
                            ))
                        : Container(
                            padding: EdgeInsets.all(20.r),
                            height: 120.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.r),
                                color: const Color(0xffEFEFEF),
                                border: Border.all(
                                  color: const Color(0xffEFEFEF),
                                )),
                            child: Icon(
                              Icons.person,
                              size: 50.sp,
                              color: AppColors.mainColor,
                            ),
                          ),
                    InkWell(
                      onTap: () {
                        registerCubit.uploadProfilePicture();
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColors.mainColor,
                        radius: 20.r,
                        child: const Icon(
                          Icons.camera_alt,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
