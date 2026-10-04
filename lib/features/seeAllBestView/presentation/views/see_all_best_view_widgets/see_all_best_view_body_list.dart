import 'package:by3ly/features/seeAllBestView/data/models/sell_all_best_view_model.dart';
import 'package:by3ly/features/seeAllBestView/presentation/views/see_all_best_view_widgets/see_all_best_view_body_list_item.dart';
import 'package:by3ly/features/seeAllBestView/presentation/views/see_all_best_view_widgets/sell_all_best_view_loading.dart';

import '../../../../../core/shared_widgets/custom_error_widget.dart';
import '../../../../../core/shared_widgets/custom_text_form_filed.dart';
import '../../../../../core/utils/app_images/app_images.dart';
import '../../../../../main_importants.dart';
 import 'package:by3ly/features/seeAllBestView/presentation/view_model/sell_all_best_view_cubit.dart';
import 'package:by3ly/features/seeAllBestView/presentation/view_model/sell_all_best_view_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../lang/locale_keys.dart';

class SeeAllBestViewBodyList extends StatefulWidget {
  const SeeAllBestViewBodyList({super.key});

  @override
  State<SeeAllBestViewBodyList> createState() =>
      _SeeAllBestViewBodyListState();
}

class _SeeAllBestViewBodyListState
    extends State<SeeAllBestViewBodyList> {
  final TextEditingController _searchController =
      TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Products> _filtered(List<Products> source) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return source;
    return source.where((p) {
      final name = (p.name ?? '').toLowerCase();
      final desc = (p.desc ?? '').toLowerCase();
      final price = (p.price ?? '').toLowerCase();
      return name.contains(query) ||
          desc.contains(query) ||
          price.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellAllBestViewCubit , SellAllBestViewStates>(
        listener: (context ,state){},
    builder:  (context ,state){
      var sellAllBestViewCubit = context.read<SellAllBestViewCubit>();
      if(state is GetAllBestViewProductsLoadingState){
        return const SellAllBestViewLoading();
      }
      if(state is GetAllBestViewProductsErrorState){
        return CustomErrorWidget(
            error: state.error.toString(),
            onTap: () => sellAllBestViewCubit.getSellAllBestView());
      }
      final products = _filtered(
        sellAllBestViewCubit.sellAllBestViewModel?.data?.products ?? [],
      );
      return Column(
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
                    onPressed: () => setState(
                        () => _searchController.clear()),
                  )
                : null,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Text(
                      _searchController.text.trim().isNotEmpty
                          ? context.tr(LocaleKeys.noResults)
                          : "لا يوجد منتجات",
                      textAlign: TextAlign.center,
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return SeeAllBestViewBodyListItem(
                        product: products[index],
                      );
                    },
                  ),
          ),
        ],
      );
    }

    );
  }
}
