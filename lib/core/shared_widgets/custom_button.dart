

import '../../main_importants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key,   this.height,   this.width,     this.btnColor, required this.btnText,required this.onPressed,   this.borderColor, this.radius}) : super(key: key);
  final double? height;
  final double? width;

  final Color? btnColor;
  final Color? borderColor;
  final double? radius;
  final Widget btnText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return    SizedBox(
      height: height ?? 48,
      width: width ?? double.infinity,
      child:  ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          textStyle: AppStyles.textStyle14W500White,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 10),
              side:   BorderSide(
                width: 1.0,
                color:borderColor ?? AppColors.mainColor,
              )
          ),
          backgroundColor: btnColor ?? AppColors.mainColor,
        ),
        child:  btnText,
      ),
    );
  }
}