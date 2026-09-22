import '../../../../../main_importants.dart';

class SellerContactButton extends StatelessWidget {
  const SellerContactButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        // privacyCubit.changeSellerDataIndex(privacyCubit.wayIndex=1);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.mainColor ,
            border: Border.all(
              color: AppColors.mainColor ,
            )
        ),
        child:   const Center(child: Text("تواصل الان",
          style: TextStyle(
            color:AppColors.whiteColor ,
          ),)),
      ),
    );
  }
}
