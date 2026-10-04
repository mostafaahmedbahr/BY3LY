import 'package:easy_localization/easy_localization.dart';
import '../../../../../main_importants.dart';
import '../../view_model/home_cubit.dart';
import '../../view_model/home_states.dart';
import 'categories_list_item.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.tr(LocaleKeys.categories),
                style: AppStyles.textStyle16W600Black,),
              TextButton(
                onPressed: (){
                  context.pushNamed(Routes.allCategoriesView);
                },
                child:   Text(context.tr(LocaleKeys.seeAll),
                  style: const TextStyle(
                      color: AppColors.mainColor
                  ),),
              ),
            ],
          ),
          SizedBox(
            height: 70.h,
            child:
            BlocConsumer<HomeCubit , HomeStates>(
                listener:(context ,state){} ,
                builder: (context ,state){
                  var homeCubit = context.read<HomeCubit>();
                  final categories =
                      homeCubit.homeModel?.data?.categories ?? [];
                  if (categories.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context , index){
                      return CategoriesListItem(
                        id: categories[index].id ?? 0,
                        image: categories[index].image ?? '',
                        name: categories[index].name ?? '',
                      );
                    },
                    separatorBuilder: (context , index){
                      return   Gap(25.w);
                    },
                    itemCount: categories.length,
                  );
                }

            ),
          ),
        ],
      ),
    );
  }
}
