import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/shared_widgets/custom_sized_box.dart';
import '../../../../../core/shared_widgets/custom_text_form_filed.dart';
import '../../../../../core/utils/app_images/app_images.dart';
import 'fav_data_list_loading.dart';
import 'fav_item_widget.dart';

class FavViewBody extends StatelessWidget {
  const FavViewBody({super.key,});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          CustomTextFormField(
            keyboardType: TextInputType.text,
            hintText: context.tr(LocaleKeys.searchWithBy3ly),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(AppImages.search),
            ),
          ),
          const CustomSizedBox(height: 20,),
          Expanded(
            child: BlocConsumer<FavCubit , FavStates>(
              listener: (context ,state){},
              builder:  (context ,state){
                var favCubit = context.read<FavCubit>();
                if (state is GetFavDataLoading) {
                  return const FavDataListLoading();
                }
                else if (state is GetFavDataError){
                  return const Text("error please try again");
                }
                return AnimationLimiter(
                  child: ListView.separated(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 800),
                        child:   SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(
                            child: FavItemWidget(
                              productId: 1,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const CustomSizedBox(height: 10,);
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
