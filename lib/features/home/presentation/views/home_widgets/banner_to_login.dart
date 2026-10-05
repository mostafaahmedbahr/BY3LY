import 'package:by3ly/features/addAdvertisements/presentation/views/add_new_ad_view.dart';
import 'package:by3ly/core/utils/guest_guard.dart';
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
          child: _buildBackground(context),
        );
      },
    );
  }

  // الخلفية + المحتوى responsive
  Widget _buildBackground(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: 105.h,
      ),
      decoration: const BoxDecoration(
        color: AppColors.mainColor,
      ),
      // clip عشان الزخارف متخرجش بره على أي مقاس
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          _buildTopRightDecoration(),
          _buildBottomLeftDecoration(),
          // المحتوى الأساسي Row بدل Positioned عشان ميحصلش overlap
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxW = constraints.maxWidth;
                // مقاسات مرنة حسب عرض الشاشة
                final bool isVeryNarrow = maxW < 300;
                final bool isNarrow = maxW < 360;

                final double imgSize =
                    (maxW * 0.105).clamp(26.0, 52.0);
                final double gap = (maxW * 0.02).clamp(4.0, 10.0);

                final double titleFont =
                    (maxW * 0.034).clamp(11.0, 15.0);
                final double btnFont =
                    (maxW * 0.028).clamp(9.0, 12.0);

                final double btnW =
                    (maxW * 0.28).clamp(80.0, 130.0);
                final double btnH =
                    (isVeryNarrow ? 24.0 : 28.0).clamp(23.0, 34.0);

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // النص + الزر ياخد المساحة المرنة
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _text(
                            "انضم الينا واحصل علي افضل العروض",
                            titleFont,
                            maxLines: 2,
                          ),
                          SizedBox(height: 2.h),
                          _text(
                            "بيعلي هو تطبيق يمكنك من خلاله بيع وشراء المنتجات",
                            titleFont * 0.92,
                            maxLines: 2,
                            fontWeight: FontWeight.w500,
                          ),
                          _text(
                            "بطريقه سهله وسريعه",
                            titleFont * 0.92,
                            maxLines: 1,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8.h),
                          _buildButton(
                            context,
                            btnW,
                            btnH,
                            btnFont,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8.w),

                    // الصور تاخد مساحة ثابتة نسبياً ومبتعملش overflow
                    Flexible(
                      flex: isNarrow ? 4 : 5,
                      child: _buildImagesGrid(
                        imgSize,
                        gap,
                        hideExtra: isVeryNarrow,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // الزخارف بمقاس مرن ومقصوصة
  Widget _buildTopRightDecoration() {
    return PositionedDirectional(
      top: 0,
      end: 0,
      child: SvgPicture.asset(
        "assets/images/Vector.svg",
        width: 70.w,
        height: 55.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildBottomLeftDecoration() {
    return PositionedDirectional(
      bottom: 0,
      start: 0,
      child: SvgPicture.asset(
        "assets/images/Vector (1).svg",
        width: 70.w,
        height: 55.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _text(
    String text,
    double fontSize, {
    int maxLines = 2,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: TextStyle(
        fontWeight: fontWeight,
        // ScreenUtil responsive مع clamp محسوب من عرض البانر
        fontSize: fontSize,
        color: AppColors.whiteColor,
        height: 1.3,
      ),
    );
  }

  // الزر responsive بدون Positioned
  Widget _buildButton(
    BuildContext context,
    double width,
    double height,
    double fontSize,
  ) {
    final bool isArabic = context.isArabic;
    return CustomButton(
      borderColor: AppColors.whiteColor,
      btnColor: AppColors.whiteColor,
      height: height,
      width: width,
      radius: 8.r,
      btnText: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          isArabic ? "انضم الان" : context.tr(LocaleKeys.joinNow),
          maxLines: 1,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
            color: AppColors.mainColor,
          ),
        ),
      ),
      onPressed: () async {
        // Guests are asked to log in before posting an ad.
        if (!await GuestGuard.requireLogin(context)) return;
        if (!context.mounted) return;
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const AddNewAdView(),
          ),
        );
      },
    );
  }

  // الصور grid مرن - Row بيتقلب تلقائي مع RTL/LTR
  Widget _buildImagesGrid(double size, double gap, {bool hideExtra = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _img("home1.png", size),
            SizedBox(width: gap),
            _img("home2.png", size),
          ],
        ),
        SizedBox(height: gap),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _img("home3.png", size),
            SizedBox(width: gap),
            _img("home4.png", size),
            if (!hideExtra) ...[
              SizedBox(width: gap),
              _img("home5.png", size),
            ],
          ],
        ),
      ],
    );
  }

  Widget _img(String name, double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: Image.asset(
        "assets/images/$name",
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}