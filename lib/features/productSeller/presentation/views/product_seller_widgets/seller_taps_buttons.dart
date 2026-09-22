import '../../../../../main_importants.dart';
import '../../view_model/product_seller_cubit.dart';
import '../../view_model/product_seller_states.dart';

class SellerTapsButtons extends StatelessWidget {
  const SellerTapsButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return     BlocBuilder<ProductSellerCubit, ProductSellerStates>(
      builder: (context,state){
        var productSellerCubit = ProductSellerCubit.get(context);
        return Row(
          children: [
            InkWell(
              onTap: (){
                productSellerCubit.changeSellerDataIndex(productSellerCubit.sellerDataIndex=1);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:productSellerCubit.sellerDataIndex==1  ?
                    AppColors.mainColor : AppColors.whiteColor,
                    border: Border.all(
                      color:productSellerCubit.sellerDataIndex==1  ?
                      AppColors.mainColor : const Color(0xffB6B6B6),
                    )
                ),
                child:   Center(child: Text("بيانات البائع",
                  style: TextStyle(
                    color: productSellerCubit.sellerDataIndex==1  ?
                    AppColors.whiteColor : AppColors.greyColor,
                  ),)),
              ),
            ),
            const SizedBox(width: 10,),
            InkWell(
              onTap: (){
                productSellerCubit.changeSellerDataIndex(productSellerCubit.sellerDataIndex=2);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:productSellerCubit.sellerDataIndex==2  ?
                    AppColors.mainColor : AppColors.whiteColor,
                    border: Border.all(
                      color:productSellerCubit.sellerDataIndex==2  ?
                      AppColors.mainColor : const Color(0xffB6B6B6),
                    )
                ),
                child:   Center(child: Text("المعروض الان",
                  style: TextStyle(
                    color: productSellerCubit.sellerDataIndex==2  ?
                    AppColors.whiteColor : AppColors.greyColor,
                  ),)),
              ),
            ),
            const SizedBox(width: 10,),
            InkWell(
              onTap: (){
                productSellerCubit.changeSellerDataIndex(productSellerCubit.sellerDataIndex=3);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: productSellerCubit.sellerDataIndex==3  ?
                    AppColors.mainColor : AppColors.whiteColor,
                    border: Border.all(
                      color:productSellerCubit.sellerDataIndex==3  ?
                      AppColors.mainColor : const Color(0xffB6B6B6),
                    )
                ),
                child:   Center(child: Text("المبيعات السابقة",
                  style: TextStyle(
                    color: productSellerCubit.sellerDataIndex==3  ?
                    AppColors.whiteColor : AppColors.greyColor,
                  ),)),
              ),
            ),
          ],
        );
      },

    );
  }
}
