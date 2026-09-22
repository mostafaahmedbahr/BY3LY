import '../../../../../main_importants.dart';

class MainCategoryInfo extends StatelessWidget {
  const MainCategoryInfo({super.key,
    required this.mainCategoryName,
    required this.mainCategoryImage,
    required this.mainCategoryTypesCount,
     });
  final String mainCategoryName;
  final String mainCategoryImage;
  final int mainCategoryTypesCount;

  @override
  Widget build(BuildContext context) {
    return   Container(
      padding: const EdgeInsets.all(10),
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.mainColor,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color : Colors.white,
            ),
            height: 54,
            width: 54,
            child: CustomNetWorkImage(imageUrl:mainCategoryImage,
              raduis: 8,
              fit: BoxFit.cover,),
          ),
          const SizedBox(width: 12,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(mainCategoryName,style: AppStyles.textStyle14W500White,),
              Text("$mainCategoryTypesCount تصنيفات  ",style: AppStyles.textStyle14W500White,),
            ],
          ),
        ],
      ),
    );
  }
}
