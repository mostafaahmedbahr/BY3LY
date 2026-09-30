import 'package:by3ly/features/productDetails/data/models/product_details_model.dart';

import '../../../../../main_importants.dart';

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
      itemCount: relatedProducts?.length ?? 0,
      itemBuilder: (context, index) {
        final item = relatedProducts![index];
        return InkWell(
          onTap: () {
            context.pushNamed(Routes.productDetailsView, arguments: {
              "type": "home",
              "productId": item.id ?? 0,
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomNetWorkImage(
                imageUrl: "${item.image}",
                raduis: 10,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120,
              ),
              const SizedBox(height: 10,),
              Text("${item.name}",
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
                  Expanded(
                    child: Text(
                      (item.location?.toString().trim().isNotEmpty ?? false)
                          ? item.location.toString()
                          : "لا يوجد",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.textStyle10W400Green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("النوع ", style: AppStyles.textStyle10W400Gray,),
                      Text("${item.type}", style: AppStyles.textStyle10W400Yellow,),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("الاثاث ", style: AppStyles.textStyle10W400Gray,),
                      Text(" ${item.model}", style: AppStyles.textStyle10W400Yellow,),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              Text("${item.price}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 5,),
              Text("${item.createdAt}",
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
