import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../features/layout/presentation/view_model/layout_cubit.dart';
import '../utils/app_images/app_images.dart';
import 'custom_text_form_filed.dart';

class ContainerSearchWidget extends StatelessWidget {
  const ContainerSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      onPressed: (){
        LayoutCubit.get(context).changeBottomNav(LayoutCubit.pageIndex=2,context);
      },
      keyboardType: TextInputType.text,
      hintText:  context.tr(LocaleKeys.searchWithBy3ly),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(AppImages.search),
      ),
    );
  }
}
