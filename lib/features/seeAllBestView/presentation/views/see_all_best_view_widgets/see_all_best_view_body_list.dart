import 'package:by3ly/features/seeAllBestView/presentation/views/see_all_best_view_widgets/see_all_best_view_body_list_item.dart';
import 'package:by3ly/features/seeAllBestView/presentation/views/see_all_best_view_widgets/sell_all_best_view_loading.dart';

import '../../../../../core/shared_widgets/custom_error_widget.dart';
import '../../../../../main_importants.dart';
 import '../../view_model/sell_all_best_view_cubit.dart';
import '../../view_model/sell_all_best_view_states.dart';

class SeeAllBestViewBodyList extends StatelessWidget {
  const SeeAllBestViewBodyList({super.key});

  @override
  Widget build(BuildContext context) {
    return   BlocConsumer<SellAllBestViewCubit , SellAllBestViewStates>(
        listener: (context ,state){},
    builder:  (context ,state){
      var sellAllBestViewCubit = context.read<SellAllBestViewCubit>();
      if(state is GetAllBestViewProductsLoadingState){
        return const SellAllBestViewLoading();
      }
      if(state is GetAllBestViewProductsErrorState){
        return CustomErrorWidget(
            error: state.error.toString(),
            onTap: (){});
      }
      return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.7,
            ),
            itemCount: sellAllBestViewCubit.sellAllBestViewModel!.data!.products!.length,
            itemBuilder: (context, index) {
              return SeeAllBestViewBodyListItem(
                product: sellAllBestViewCubit.sellAllBestViewModel!.data!.products![index],
              );
            },
          );
    }

    );
  }
}
