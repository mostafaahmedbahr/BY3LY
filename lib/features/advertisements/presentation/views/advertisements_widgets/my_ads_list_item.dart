import 'package:flutter_svg/svg.dart';

import '../../../../../main_importants.dart';
 import '../../../../productDetails/presentation/views/product_details_view.dart';
import '../../../data/models/my_ads_data_model.dart';

class MyAdsListItem extends StatelessWidget {
  const MyAdsListItem({super.key, required this.adsProduct});
  final Products adsProduct;
  @override
  Widget build(BuildContext context) {
    List<String> names = [
      "الرسائل",
      "المشاهدات",
      "التقييمات",
      "الاعجابات",
    ];
    List<String> svgsIcons = [
      "assets/images/Chat.svg",
      "assets/images/eye (1).svg",
      "assets/images/Star.svg",
      "assets/images/Heart.svg",
    ];

    List<String> values = [
      "7",
      "32",
      "4",
      "14",
    ];
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child:   const ProductDetailsView(
              productId: 1,
              type: "home",
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 1,
              spreadRadius: 1,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child:Column(
          children: [
            Row(
              children: [
                  CustomNetWorkImage(
                  imageUrl: "${adsProduct.image}",
                  raduis: 10,
                  fit: BoxFit.cover,
                  width: 175,
                  height: 120,
                ),
                const  CustomSizedBox(width: 10,),
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("فيلا للايجار اليومي والشهري",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff000000),
                          ),),
                        Row(
                          children: [
                            SvgPicture.asset(AppImages.location),
                            const  CustomSizedBox(width: 5,),
                            const Text("مدينة نصر",style: AppStyles.textStyle10W400Green,),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("النوع ",style: AppStyles.textStyle10W400Gray,),
                                Text(" ايجار",style: AppStyles.textStyle10W400Yellow,),
                              ],
                            ),
                            Row(
                              children: [
                                Text("الاثاث ",style: AppStyles.textStyle10W400Gray,),
                                Text(" مفروشة",style: AppStyles.textStyle10W400Yellow,),
                              ],
                            ),
                          ],
                        ),
                        const Text("250,000 LE",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("منذ واحد يوم ",
                              style: AppStyles.textStyle10W400Green.copyWith(
                                color: const Color(0xff7A7A7A),
                              ),),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 50,
                  width: 80 ,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.mainColor
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(svgsIcons[0],),
                          const SizedBox(width: 5,),
                          Text(names[0],
                            style: AppStyles.textStyle10W400Green,),
                        ],
                      ),
                      Text(values[0],
                        style: AppStyles.textStyle10W400Green.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.mainColor
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(svgsIcons[1],),
                          const SizedBox(width: 5,),
                          Text(names[1],
                            style: AppStyles.textStyle10W400Green,),
                        ],
                      ),
                      Text(values[1],
                        style: AppStyles.textStyle10W400Green.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.mainColor
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(svgsIcons[2],),
                          const SizedBox(width: 5,),
                          Text(names[2],
                            style: AppStyles.textStyle10W400Green,),
                        ],
                      ),
                      Text(values[2],
                        style: AppStyles.textStyle10W400Green.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.mainColor
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(svgsIcons[3],height: 16,),
                          const SizedBox(width: 5,),
                          Text(names[3],
                            style: AppStyles.textStyle10W400Green,),
                        ],
                      ),
                      Text(values[3],
                        style: AppStyles.textStyle10W400Green.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    btnText: Row(
                      children: [
                        IconButton(
                          onPressed: (){},
                          icon: const Icon(
                            Icons.arrow_drop_down_circle_sharp,
                            color: Colors.white,
                          ),
                        ),
                        const Text("خيارات",style: AppStyles.textStyle14W500White,),
                      ],
                    ),

                    onPressed: (){},
                  ),
                ),
                const SizedBox(width: 20,),
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
