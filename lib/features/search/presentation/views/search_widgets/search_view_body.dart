import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/features/search/presentation/view_model/search_cubit.dart';
import 'package:by3ly/features/search/presentation/view_model/search_states.dart';
import 'package:by3ly/features/search/presentation/views/search_widgets/search_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../../core/shared_widgets/custom_text_form_filed.dart';
import '../../../../../core/utils/app_images/app_images.dart';
import '../../../../../lang/locale_keys.dart';
 import 'all_products_search_list_loading.dart';

class SearchViewBody extends StatefulWidget {
  const SearchViewBody({super.key});

  @override
  State<SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<SearchViewBody> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> filteredProducts = [];
  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = SearchCubit.get(context).allProductsForSearchList;
      } else {
        filteredProducts = SearchCubit.get(context).allProductsForSearchList.where((product) {
          return product.name!.toLowerCase().contains(query.toLowerCase()) ||
              product.price.toString().contains(query);
        }).toList();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          CustomTextFormField(
            controller: _searchController,
            keyboardType: TextInputType.text,
            hintText: context.tr(LocaleKeys.searchWithBy3ly),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(AppImages.search),
            ),
            onChanged: (value) {
              filterSearchResults(value);
            },
          ),
          const CustomSizedBox(height: 20,),
          Expanded(
            child: BlocConsumer<SearchCubit , SearchStates>(
              listener: (context ,state){},
              builder:  (context ,state){
                var searchCubit = context.read<SearchCubit>();
                if (state is GetAllProductsForSearchLoading) {
                  return const  AllProductsSearchListLoading();
                }
                else if (state is GetAllProductsForSearchError){
                  return const Text("error please try again");
                }
                return AnimationLimiter(
                  child: ListView.separated(
                    itemCount:_searchController.text.isEmpty ?
                    searchCubit.allProductsForSearchList.length  : filteredProducts.length,
                   // itemCount: searchCubit.allProductsForSearchList.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child:   SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: SearchItemWidget(
                              product:
                              _searchController.text.isEmpty ?
                              searchCubit.allProductsForSearchList[index]  :
                              filteredProducts[index],
                              //product: searchCubit.allProductsForSearchList[index],
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
