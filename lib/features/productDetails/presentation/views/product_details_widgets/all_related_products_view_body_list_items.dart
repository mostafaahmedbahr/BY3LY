import 'package:flutter_svg/svg.dart';

import '../../../../../main_importants.dart';
import '../../../data/models/product_details_model.dart';
import '../product_details_view.dart';

class AllRelatedProductsViewBodyListItems extends StatelessWidget {
  const AllRelatedProductsViewBodyListItems({super.key, this.relatedProducts});
  final List<RelatedProducts>? relatedProducts;
  @override
  Widget build(BuildContext context) {
    return
    GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.7,
      ),
      itemCount: relatedProducts!.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child:   ProductDetailsView(
                    productId: relatedProducts![index].id!,
                    type: "home"),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomNetWorkImage(
                imageUrl: "${relatedProducts![index].image}",
                raduis: 10,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120,
              ),
              const SizedBox(height: 10,),
              Text("${relatedProducts![index].name}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                ),),
              const SizedBox(height: 5,),
              Row(
                children: [
                  SvgPicture.asset(AppImages.location),
                  const SizedBox(width: 5,),
                  const Text("مدينة نصر", style: AppStyles.textStyle10W400Green,),
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("النوع ", style: AppStyles.textStyle10W400Gray,),
                      Text("${relatedProducts![index].type}", style: AppStyles.textStyle10W400Yellow,),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("الاثاث ", style: AppStyles.textStyle10W400Gray,),
                      Text(" ${relatedProducts![index].model}", style: AppStyles.textStyle10W400Yellow,),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              Text("${relatedProducts![index].price}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 5,),
              Text("${relatedProducts![index].createdAt}",
                style: AppStyles.textStyle10W400Green.copyWith(
                  color: const Color(0xff7A7A7A),
                ),),
            ],
          ),
        );
      },
    );
  }
}
