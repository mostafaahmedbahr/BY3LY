 import 'package:by3ly/main_importants.dart';

class CustomGlobalAppbarWidget extends StatelessWidget {
  const CustomGlobalAppbarWidget({super.key,  this.arrowBackOrNot = false});
  final bool arrowBackOrNot;
  @override
  Widget build(BuildContext context) {
     return Stack(
      children: [
        Image.asset(AppImages.appBarImage,
          fit: BoxFit.cover,
          width: double.infinity,),
        if(arrowBackOrNot)
        IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined,
            color: Colors.white,),
        ),

        Padding(
          padding:
        context.isArabic?
            EdgeInsets.only(top: 30.h,right: 10.w) :
          EdgeInsets.only(top: 30.h,left: MediaQuery.of(context).size.width*0.48),
          child: Image.asset(AppImages.logo2,
            width: 200.w,),
        ),
      ],
    );
  }
}
