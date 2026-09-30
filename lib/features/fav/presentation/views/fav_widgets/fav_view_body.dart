import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:by3ly/features/fav/data/models/fav_model.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/shared_widgets/custom_sized_box.dart';
import '../../../../../core/shared_widgets/custom_text_form_filed.dart';
import '../../../../../core/utils/app_images/app_images.dart';
import 'fav_data_list_loading.dart';
import 'fav_item_widget.dart';

class FavViewBody extends StatefulWidget {
  const FavViewBody({super.key,});
  @override
  State<FavViewBody> createState() => _FavViewBodyState();
}

class _FavViewBodyState extends State<FavViewBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Favourites> _filtered(List<Favourites> source) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return source;
    return source.where((f) {
      final name = (f.name ?? '').toLowerCase();
      final desc = (f.desc ?? '').toLowerCase();
      return name.contains(query) || desc.contains(query);
    }).toList();
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
            suffixIcon: _searchController.text.trim().isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () =>
                        setState(() => _searchController.clear()),
                  )
                : null,
            onChanged: (_) => setState(() {}),
          ),
          const CustomSizedBox(height: 20,),
          Expanded(
            child: BlocConsumer<FavCubit , FavStates>(
              listener: (context ,state){
                if (state is RemoveProductFromFavSuccess) {
                  final msg = (state.removeProductFromFavModel.message
                                  ?.trim()
                                  .isNotEmpty ??
                              false)
                      ? state.removeProductFromFavModel.message!
                      : context.tr(LocaleKeys.removedFromFav);
                  CherryToast.success(
                    title: Text(msg,
                        style: const TextStyle(color: AppColors.mainColor)),
                  ).show(context);
                } else if (state is RemoveProductFromFavError ||
                    state is FavToggleError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state is RemoveProductFromFavError
                            ? state.message
                            : (state as FavToggleError).message,
                      ),
                    ),
                  );
                }
              },
              builder:  (context ,state){
                var favCubit = context.read<FavCubit>();
                if (state is GetFavDataLoading &&
                    favCubit.favDataModel?.data?.favourites == null) {
                  return const FavDataListLoading();
                }
                else if (state is GetFavDataError &&
                    favCubit.favDataModel?.data?.favourites == null){
                  return CustomErrorWidget(
                    error: state.message,
                    onTap: () => favCubit.getFavData(),
                  );
                }
                final items = _filtered(
                    favCubit.favDataModel?.data?.favourites ??
                        <Favourites>[]);
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      context.tr(LocaleKeys.noResults),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return FavItemWidget(
                      favourite: items[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const CustomSizedBox(height: 10,);
                  },
                );
              },

            ),
          ),
        ],
      ),
    );
  }
}
