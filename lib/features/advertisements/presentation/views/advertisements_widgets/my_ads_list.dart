import '../../../../../main_importants.dart';
import '../../../data/models/my_ads_data_model.dart';
import 'my_ads_list_item.dart';

class MyAdsList extends StatelessWidget {
  const MyAdsList({super.key,required this.products});
  final List<Products> products;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (context,index){
          return   MyAdsListItem(
            adsProduct: products[index],
          );
        },
        separatorBuilder: (context,index){
          return const SizedBox(height: 15,);
        },
        itemCount: products.length,
      ),
    );
  }
}
