import 'package:by3ly/main_importants.dart';

/// Branded hero band used across the auth screens: the green wave image
/// with the BY3LY logo centered beneath it.
class CustomGlobalAppbarWidget extends StatelessWidget {
  const CustomGlobalAppbarWidget({super.key, this.arrowBackOrNot = false});

  final bool arrowBackOrNot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Image.asset(
          AppImages.appBarImage,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        if (arrowBackOrNot)
          PositionedDirectional(
            top: 12,
            start: 4,
            child: SafeArea(
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: 30.h, bottom: 12.h),
          child: Image.asset(
            AppImages.brandSloganTransparent,
            width: 220.w,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
