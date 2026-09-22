import 'package:by3ly/main_importants.dart';
import 'package:flutter_svg/svg.dart';

import '../../view_model/product_seller_cubit.dart';
import '../../view_model/product_seller_states.dart';

class ProductSellerReviewsInfo extends StatelessWidget {
  const ProductSellerReviewsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductSellerCubit, ProductSellerStates>(
      builder: (context,state){
        var productSellerCubit = ProductSellerCubit.get(context);
        var seller = productSellerCubit.productSellerModel!.data!.seller!;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.mainColor,
                        ),
                        child: SvgPicture.asset(
                          AppImages.person,
                          colorFilter:const ColorFilter.mode(Colors.white,
                              BlendMode.srcIn) ,
                        ),
                      ),
                      const CustomSizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("الاسم",style: AppStyles.textStyle10W400Gray,),
                          Text("${seller.name}",style: AppStyles.textStyle10W400Green.copyWith(
                              fontSize: 14
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.mainColor,
                        ),
                        child: SvgPicture.asset(
                          AppImages.email,
                          colorFilter: const ColorFilter.mode(
        Colors.white, BlendMode.srcIn)
                          ),

                        ),

                      const CustomSizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("الايميل",style: AppStyles.textStyle10W400Gray,),
                          Text("${seller.email}",style: AppStyles.textStyle10W400Green.copyWith(
                              fontSize: 14
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const CustomSizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.mainColor,
                        ),
                        child: SvgPicture.asset(AppImages.phone,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn)),
                      ),
                      const CustomSizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("الرقم",style: AppStyles.textStyle10W400Gray,),
                          Text("${seller.phone}",style: AppStyles.textStyle10W400Green.copyWith(
                              fontSize: 14
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.mainColor,
                        ),
                        child: SvgPicture.asset(AppImages.location,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn)),
                      ),
                      const CustomSizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("الموقع",style: AppStyles.textStyle10W400Gray,),
                          Text("${seller.cityName} / ${seller.centerName}",style: AppStyles.textStyle10W400Green.copyWith(
                              fontSize: 14
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const CustomSizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Row(
                  children: [
                    const Text("تقييمات البائع",style: AppStyles.textStyle16W600Black,),
                    const CustomSizedBox(width: 6),
                    Text("( ${seller.countCommenets} )"),
                  ],
                ),
                TextButton(onPressed: (){},
                  child: Text("مشاهدة الكل",style: AppStyles.textStyle12W600Gary.copyWith(
                    color: AppColors.mainColor,
                  ),),),
              ],
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                                Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CustomNetWorkImage(
                                        imageUrl: "${seller.commenets![index].image}",
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                        raduis: 10,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text("${seller.commenets![index].user}",), // Seller name
                                    ],
                                  ),
                                ],
                              ),
                              const CustomSizedBox(width: 10,),
                              Row(
                                children: [
                                  SvgPicture.asset(AppImages.star1),
                                  const CustomSizedBox(width: 5,),
                                    Text("${seller.commenets![index].rate}", style: const TextStyle(
                                      color: AppColors.yellowColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                  ),),
                                ],
                              ),
                            ],
                          ),
                            Text("${seller.commenets![index].createdAt}"),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Add the comment below the name
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0),
                        child: Text(
                          "${seller.commenets![index].commenet}", // Here you can use a dynamic comment from the model
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            height: 1.5, // Set the line height to give space between lines
                          ),
                          maxLines: 3, // Limit the lines to 3
                          overflow: TextOverflow.ellipsis, // Show "..." if text overflows
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 15,
                );
              },
              itemCount: seller.commenets!.length,
            ),
          ],
        );
      },
    );
  }
}
