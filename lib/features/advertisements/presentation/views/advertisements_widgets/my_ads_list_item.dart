
import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';

import '../../../../../main_importants.dart';
import '../../../data/models/my_ads_data_model.dart';

class MyAdsListItem extends StatelessWidget {
  const MyAdsListItem({super.key, required this.adsProduct});
  final Ads adsProduct;

  bool get _isActive => adsProduct.isPaused != true;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData(
        icon: AppImages.star,
        label: "التقييم",
        value: adsProduct.rate?.toString() ?? "-",
      ),
      _StatData(
        icon: "assets/images/Chat.svg",
        label: "التعليقات",
        value: adsProduct.countCommenets?.toString() ?? "-",
      ),
      _StatData(
        icon: "assets/images/eye (1).svg",
        label: "المراجعات",
        value: adsProduct.reviewsCount?.toString() ?? "-",
      ),
    ];
    return InkWell(
      onTap: () {
        context.pushNamed(Routes.productDetailsView, arguments: {
          "type": "home",
          "productId": adsProduct.id ?? 0,
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFF0F0F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CustomNetWorkImage(
                      imageUrl: adsProduct.image ?? '',
                      raduis: 12,
                      fit: BoxFit.cover,
                      width: 110,
                      height: 120,
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isActive
                              ? AppColors.mainColor
                              : const Color(0xff9AA0A6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _isActive ? "نشط" : "غير نشط",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const CustomSizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        adsProduct.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1F2937),
                        ),
                      ),
                      const CustomSizedBox(height: 4,),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.location,
                            width: 13,
                            height: 13,
                          ),
                          const CustomSizedBox(width: 4,),
                          Expanded(
                            child: Text(
                              (adsProduct.location
                                          ?.toString()
                                          .trim()
                                          .isNotEmpty ??
                                      false)
                                  ? adsProduct.location.toString()
                                  : "لا يوجد",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.textStyle10W400Green,
                            ),
                          ),
                        ],
                      ),
                      const CustomSizedBox(height: 4,),
                      Text(
                        [adsProduct.type, adsProduct.model]
                            .where((e) =>
                                (e?.trim().isNotEmpty ?? false))
                            .join('  •  '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xff9AA0A6)),
                      ),
                      const CustomSizedBox(height: 6,),
                      Text(
                        adsProduct.price ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff1F2937),
                        ),
                      ),
                      const CustomSizedBox(height: 2,),
                      Text(
                        adsProduct.createdAt ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xffB0B5BB)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                for (int i = 0; i < stats.length; i++) ...[
                  Expanded(child: _StatBox(stat: stats[i])),
                  if (i != stats.length - 1) const SizedBox(width: 8),
                ],
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    btnText: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_drop_down_circle_sharp,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        const Text("خيارات",
                          style: AppStyles.textStyle14W500White,),
                      ],
                    ),
                    onPressed: (){},
                  ),
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: CustomButton(
                    btnColor: AppColors.yellowColor,
                    borderColor: AppColors.yellowColor,
                    btnText:  const Text("وقف الاعلان",
                      style: AppStyles.textStyle14W500White,),
                    onPressed: (){},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatData {
  final String icon;
  final String label;
  final String value;

  const _StatData({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.stat});

  final _StatData stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAF9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SvgPicture.asset(stat.icon, width: 14, height: 14),
              const SizedBox(width: 5,),
              Expanded(
                child: Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.textStyle10W400Green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xff1F2937),
            ),
          ),
        ],
      ),
    );
  }
}
