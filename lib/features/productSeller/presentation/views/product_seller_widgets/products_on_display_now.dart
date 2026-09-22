import 'package:by3ly/features/productSeller/presentation/views/product_seller_widgets/products_on_display_now_item.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../../main_importants.dart';
import '../../../data/models/product_seller_model.dart';

class ProductsOnDisplayNow extends StatelessWidget {
  const ProductsOnDisplayNow({super.key, this.products});
  final List<Products>? products;
  @override
  Widget build(BuildContext context) {
    return  AnimationLimiter(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount:products!.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child:   SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: ProductsOnDisplayNowItem(
                  product: products![index],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const CustomSizedBox(height: 10,);
        },
      ),
    );
  }
}
