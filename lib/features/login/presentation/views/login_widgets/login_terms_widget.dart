import 'package:easy_localization/easy_localization.dart';
import '../../../../../main_importants.dart';

class LoginTermsWidget extends StatelessWidget {
  const LoginTermsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Text(context.tr(LocaleKeys.loginTermsMsg1),
           style: AppStyles.textStyle10W400Gray,
         ),
        Gap(5.w),
         InkWell(
           onTap: (){
             // Opens the terms page coming from GET /api/terms.
             context.pushNamed(Routes.termsView);
           },
           child:  Text(context.tr(LocaleKeys.loginTermsMsg2),
           style: AppStyles.textStyle10W400Green,
           ),
         ),
      ],
    );
  }
}
