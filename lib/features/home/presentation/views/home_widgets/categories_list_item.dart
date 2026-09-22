import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoriesListItem extends StatelessWidget {
  const CategoriesListItem({super.key, required this.image, required this.name});
  final String image;
  final String name;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Column(
        children: [
     //     SvgPicture.asset(image,fit: BoxFit.cover,),
          CustomNetWorkImage(imageUrl: image,
            raduis: 10,
            height: 50,
            width: 60,
            fit: BoxFit.cover,
          ),
          Text(name,style: const TextStyle(
            color: AppColors.mainColor,
            fontSize: 14,
            fontWeight: FontWeight.w600
          ),),
        ],
      ),
    );
  }
}
