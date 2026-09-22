import 'package:easy_localization/easy_localization.dart';
  import '../../../../../main_importants.dart';
 import '../../../../seeAllBestView/presentation/views/see_all_best_view.dart';
import '../../../data/models/home_model.dart';
import 'best_view_products_list.dart';

class BestViewProducts extends StatelessWidget {
  const BestViewProducts({super.key,   this.bestView});
  final List<BestView>? bestView;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20, left: 20, right: 20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.tr(LocaleKeys.bestView),
                style: AppStyles.textStyle16W600Black,),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: const SeeAllView(),
                    ),
                  );
                },
                child: Text(context.tr(LocaleKeys.seeAll),
                  style: const TextStyle(
                      color: AppColors.mainColor
                  ),),
              ),
            ],
          ),
          const SizedBox(height: 10,),
            BestViewProductsList(
            bestView: bestView,
          ),

        ],
      ),
    );
  }
}
