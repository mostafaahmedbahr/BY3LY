import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class NoDataWidget extends StatelessWidget {
  final String image;
  final String text;
  const NoDataWidget({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(image,
          height: 175,
          width: 235,
          fit: BoxFit.cover,),
          const CustomSizedBox(height: 20,),
          Text(text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.mainColor,
            fontSize: 24,
          ),),
        ],
      ),
    );
  }
}
