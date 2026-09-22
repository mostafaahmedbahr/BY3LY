import '../../../../../main_importants.dart';
import '../../../../productDetails/presentation/views/product_details_view.dart';
import '../../../data/models/all_sub_categories_products_model.dart';

class AllSubCategoriesProductsListItem extends StatelessWidget {
  const AllSubCategoriesProductsListItem({super.key, required this.product});
  final Products product;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.grey2Color,
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed(Routes.productDetailsView,
          arguments: {
            "type" :  "home",
            "productId" :  product.id,
              });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomNetWorkImage(
              imageUrl: "${product.image}",
              raduis: 10.r,
              fit: BoxFit.contain,
              width: double.infinity,
              height: 120.h,
            ),
            Gap(10.h),
            Text(product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:   TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff000000),
              ),),
            Gap(5.h),
            Row(
              children: [
                SvgPicture.asset(AppImages.location),
                Gap(5.h),
                  Text(product.address,
                    style: AppStyles.textStyle10W400Green,),
              ],
            ),
            Gap(5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text("النوع ", style: AppStyles.textStyle10W400Gray,),
                    Text(product.type, style: AppStyles.textStyle10W400Yellow,),
                  ],
                ),
                Row(
                  children: [
                    const Text("الاثاث ", style: AppStyles.textStyle10W400Gray,),
                    Text(" ${product.model}", style: AppStyles.textStyle10W400Yellow,),
                  ],
                ),
              ],
            ),
            Gap(5.h),
            Text(product.price,
                style:   TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                )),
            Gap(5.h),
            Text(product.createdAt,
              style: AppStyles.textStyle10W400Green.copyWith(
                color: const Color(0xff7A7A7A),
              ),),
          ],
        ),
      ),
    );
  }
}
