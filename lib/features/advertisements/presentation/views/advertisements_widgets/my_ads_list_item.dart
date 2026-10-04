
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
        tint: const Color(0xffFFF4D6),
        label: "التقييم",
        value: adsProduct.rate?.toString() ?? "-",
      ),
      _StatData(
        icon: "assets/images/Chat.svg",
        tint: const Color(0xffE3F2FD),
        label: "التعليقات",
        value: adsProduct.countCommenets?.toString() ?? "-",
      ),
      _StatData(
        icon: "assets/images/eye (1).svg",
        tint: const Color(0xffE6F4EF),
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
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFF0F0F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
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
                      raduis: 14,
                      fit: BoxFit.cover,
                      width: 104,
                      height: 118,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.vertical(
                            bottom: Radius.circular(14),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _isActive
                                    ? const Color(0xff34C759)
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _isActive ? "نشط" : "غير نشط",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                          fontSize: 13.5,
                          height: 1.4,
                          fontWeight: FontWeight.w700,
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
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xff9AA0A6)),
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
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12,),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xffF8FAF9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  for (int i = 0; i < stats.length; i++) ...[
                    Expanded(
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: stats[i].tint,
                              borderRadius:
                                  BorderRadius.circular(9),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                stats[i].icon,
                                width: 15,
                                height: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                stats[i].value,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff1F2937),
                                ),
                              ),
                              Text(
                                stats[i].label,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff9AA0A6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (i != stats.length - 1)
                      Container(
                        width: 1,
                        height: 34,
                        color: const Color(0xFFE5E7EB),
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings_outlined,
                      size: 18,
                      color: AppColors.mainColor,
                    ),
                    label: const Text(
                      "خيارات",
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: AppColors.mainColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isActive
                          ? AppColors.yellowColor
                          : AppColors.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Text(
                      _isActive ? "وقف الاعلان" : "تفعيل الاعلان",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
  final Color tint;
  final String label;
  final String value;

  const _StatData({
    required this.icon,
    required this.tint,
    required this.label,
    required this.value,
  });
}
