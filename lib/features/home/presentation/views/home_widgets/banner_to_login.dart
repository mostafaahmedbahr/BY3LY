import 'package:by3ly/features/layout/presentation/view_model/layout_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../main_importants.dart';
import '../../view_model/home_cubit.dart';
import '../../view_model/home_states.dart';

class BannerToLogin extends StatelessWidget {
  const BannerToLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Stack(
            children: [
              _buildBackground(),

              _buildTopRightDecoration(),
              _buildBottomLeftDecoration(),

              _buildTextSection(),

              _buildButton(context, context.isArabic),

              _buildImagesGrid(!context.isArabic),
            ],
          ),
        );
      },
    );
  }

  // الخلفية
  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: 100.h,
      color: AppColors.mainColor,
    );
  }

  // الزخارف
  Widget _buildTopRightDecoration() {
    return Positioned(
      right: 0,
      child: SvgPicture.asset("assets/images/Vector.svg"),
    );
  }

  Widget _buildBottomLeftDecoration() {
    return Positioned(
      bottom: 0,
      left: 0,
      child: SvgPicture.asset("assets/images/Vector (1).svg"),
    );
  }

  // النص
  Widget _buildTextSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text("انضم الينا واحصل علي افضل العروض"),
          _text("بيعلي هو تطبيق يمكنك من خلاله بيع وشراء المنتجات"),
          _text("بطريقه سهله وسريعه"),
        ],
      ),
    );
  }

  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12.sp,
        color: AppColors.whiteColor,
      ),
    );
  }

  // الزر
  Widget _buildButton(BuildContext context, bool isArabic) {
    final button = CustomButton(
      borderColor: AppColors.whiteColor,
      btnColor: AppColors.whiteColor,
      height: 23.h,
      width: 100.w,
      btnText: Text(
        isArabic ? "انضم الان" : context.tr(LocaleKeys.joinNow),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10.sp,
          color: AppColors.mainColor,
        ),
      ),
      onPressed: () {
        context.read<LayoutCubit>().changeBottomNav(2, context);
      },
    );

    return Positioned(
      bottom: 10.h,
      left: isArabic ? null : 20.w,
      right: isArabic ? 20.w : null,
      child: button,
    );
  }

  // الصور
  Widget _buildImagesGrid(bool isRtl) {
    return Positioned(
      bottom: 10.h,
      left: isRtl ? null : 10.w,
      right: isRtl ? 10.w : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              _img("home1.png"),
              Gap(10.w),
              _img("home2.png"),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              _img("home3.png"),
              Gap(10.w),
              _img("home4.png"),
              Gap(10.w),
              _img("home5.png"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _img(String name) {
    return Image.asset("assets/images/$name");
  }
}