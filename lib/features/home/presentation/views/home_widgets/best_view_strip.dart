import 'package:by3ly/core/shared_widgets/product_cards.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../seeAllBestView/presentation/views/see_all_best_view.dart';
import '../../../data/models/home_model.dart';

/// Best-view section: title + horizontal scroll of the first 5 items.
/// "See all" opens the full grid page.
class BestViewStrip extends StatelessWidget {
  const BestViewStrip({super.key, required this.bestView});

  final List<BestView> bestView;

  @override
  Widget build(BuildContext context) {
    if (bestView.isEmpty) return const SizedBox.shrink();
    final visible = bestView.take(5).toList();
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr(LocaleKeys.bestView),
                  style: AppStyles.textStyle16W600Black,
                ),
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
                  child: Text(
                    context.tr(LocaleKeys.seeAll),
                    style: const TextStyle(
                        color: AppColors.mainColor),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            // ارتفاع ثابت (مش .h) لأن محتوى الكارت بمقاسات ثابتة بالبكسل
            // والـ .h كان بيصغر على الشاشات القصيرة ويعمل overflow
            height: 235,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: visible.length,
              separatorBuilder: (_, __) => Gap(12.w),
              itemBuilder: (context, index) {
                final item = visible[index];
                return SizedBox(
                  width: 160.w,
                  child: ProductGridCard(
                    imageUrl: item.image ?? '',
                    title: item.name ?? '',
                    location: item.location?.toString(),
                    type: item.type,
                    model: item.model,
                    price: item.price,
                    date: item.createdAt,
                    rating: item.rate?.toString(),
                    productId: item.id,
                    initialIsFavourite:
                        item.isFavourite == true,
                    imageHeight: 105,
                    onTap: () {
                      context.pushNamed(
                          Routes.productDetailsView,
                          arguments: {
                            "type": "home",
                            "productId": item.id ?? 0,
                          });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
