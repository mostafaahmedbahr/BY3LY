import 'package:flutter_svg/svg.dart';

import '../../../../../main_importants.dart';
import '../../../data/models/product_details_model.dart';

class RelatedProductsList extends StatelessWidget {
  const RelatedProductsList({super.key,required this.relatedProductsList});
  final List<RelatedProducts>? relatedProductsList;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder:  (context , index ){
          return    Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                CustomNetWorkImage(
                imageUrl: relatedProductsList![index].image!,
                raduis: 10,
                fit: BoxFit.cover,
                width: 165,
                height: 165,
              ),
              const  CustomSizedBox(height: 5,),
                SizedBox(
                  width: 165,
                  child: Text("${relatedProductsList![index].name}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
                  ),),
                ),
              const  CustomSizedBox(height: 5,),
              Row(
                children: [
                  SvgPicture.asset(AppImages.location),
                  const  CustomSizedBox(width: 5,),
                    Text("${relatedProductsList![index].address}",style: AppStyles.textStyle10W400Green,),
                ],
              ),
              const  CustomSizedBox(height: 5,),
               Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("النوع ",style: AppStyles.textStyle10W400Gray,),
                      Text("${relatedProductsList![index].type}",style: AppStyles.textStyle10W400Yellow,),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("الماركة ",style: AppStyles.textStyle10W400Gray,),
                      Text("${relatedProductsList![index].marka}",style: AppStyles.textStyle10W400Yellow,),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("المودل ",style: AppStyles.textStyle10W400Gray,),
                      Text("${relatedProductsList![index].model}",style: AppStyles.textStyle10W400Yellow,),
                    ],
                  ),
                ],
              ),
              const  CustomSizedBox(height: 5,),
                Text("${relatedProductsList![index].price}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          );
        },
        separatorBuilder: (context , index ){
          return const SizedBox(width: 10,);
        },
        itemCount: relatedProductsList!.length,
      ),
    );
  }
}
