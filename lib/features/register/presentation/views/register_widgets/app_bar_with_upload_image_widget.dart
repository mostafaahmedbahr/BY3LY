import 'package:by3ly/features/register/presentation/view_model/register_cubit.dart';
import 'package:by3ly/features/register/presentation/view_model/register_states.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                top: 6,
                right: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Frosted circle back button — matches the app's premium bars.
                    Semantics(
                      button: true,
                      label: context.tr(LocaleKeys.back),
                      child: IconButton(
                        onPressed: Navigator.of(context).pop,
                        icon: Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Icon(
                            Directionality.of(context) == TextDirection.rtl
                                ? Icons.arrow_back_ios_rounded
                                : Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      context.tr(LocaleKeys.register),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),

                    // Mirror spacer — keeps the title optically centered.
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              /// image
              Positioned(
                bottom: 0,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 120.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: ClipOval(
                        child: registerCubit.profileImage != null &&
                                registerCubit.profileImage!.path != ""
                            ? Image.file(
                                registerCubit.profileImage!,
                                fit: BoxFit.cover,
                                height: 120.h,
                                width: 120.w,
                              )
                            : Container(
                                padding: EdgeInsets.all(24.r),
                                color: AppColors.surfaceVariant,
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 50.sp,
                                  color: AppColors.accent,
                                ),
                              ),
                      ),
                    ),
                    Material(
                      color: AppColors.yellowColor,
                      shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.4),
                      ),
                      elevation: 3,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          registerCubit.uploadProfilePicture();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 18,
                            color: Color(0xff1A1205),
                          ),
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
