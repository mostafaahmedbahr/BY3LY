import 'package:by3ly/main_importants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class CustomLoading extends StatelessWidget {
  const CustomLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(
        size: 50.sp, color: AppColors.mainColor,
      ),
    );
  }
}
