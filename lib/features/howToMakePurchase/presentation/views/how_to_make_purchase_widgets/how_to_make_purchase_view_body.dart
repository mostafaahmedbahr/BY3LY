import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/features/howToMakePurchase/data/repos/how_to_make_purchase_repos_imple.dart';
import 'package:by3ly/features/howToMakePurchase/presentation/view_model/how_to_make_purchase_cubit.dart';
import 'package:by3ly/features/howToMakePurchase/presentation/view_model/how_to_make_purchase_states.dart';
import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'purchase_footer.dart';
import 'purchase_instructions_card.dart';

class HowToMakePurchaseViewBody extends StatelessWidget {
  const HowToMakePurchaseViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HowToMakePurchaseCubit(
          getIt.get<HowToMakePurchaseRepoImpl>())
        ..getHowToMakePurchaseData(),
      child: BlocBuilder<HowToMakePurchaseCubit,
          HowToMakePurchaseStates>(
        builder: (context, state) {
          final cubit = HowToMakePurchaseCubit.get(context);

          if (state is GetHowToMakePurchaseDataLoadingState &&
              cubit.howToMakePurchaseModel?.data?.html == null) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: const [
                SimmerLoading(height: 40, raduis: 10),
                SizedBox(height: 12),
                SimmerLoading(height: 90, raduis: 16),
                SizedBox(height: 12),
                SimmerLoading(height: 90, raduis: 16),
                SizedBox(height: 12),
                SimmerLoading(height: 60, raduis: 16),
              ],
            );
          }

          if (state is GetHowToMakePurchaseDataErrorState &&
              cubit.howToMakePurchaseModel?.data?.html == null) {
            return CustomErrorWidget(
              error: state.error,
              onTap: () => cubit.getHowToMakePurchaseData(),
            );
          }

          final data = cubit.howToMakePurchaseModel?.data;
          final isRtl = (data?.direction ?? 'rtl') != 'ltr';

          return Directionality(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                if (data != null) PurchaseInstructionsCard(data: data),
                PurchaseFooter(updatedAt: data?.updatedAt),
              ],
            ),
          );
        },
      ),
    );
  }
}
