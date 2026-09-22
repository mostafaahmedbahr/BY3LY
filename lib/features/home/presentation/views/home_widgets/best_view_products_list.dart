import '../../../../../main_importants.dart';
import '../../../data/models/home_model.dart';
import 'best_view_products_list_item.dart';

class BestViewProductsList extends StatelessWidget {
  const BestViewProductsList({super.key, this.bestView});
  final List<BestView>? bestView;
  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.7,
      ),
      itemCount: bestView!.length,
      itemBuilder: (context, index) {
        return BestViewProductsListItem(
          bestView: bestView![index],
        );
      },
    );
  }
}
