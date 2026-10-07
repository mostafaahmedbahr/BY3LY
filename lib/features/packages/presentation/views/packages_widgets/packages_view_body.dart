import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/shared_widgets/custom_error_widget.dart';
import '../../../../../core/shared_widgets/custom_loading.dart';
import '../../../../../core/utils/new_toast/toast.dart';
import '../../view_model/packages_cubit.dart';
import '../../view_model/packages_states.dart';
import 'duration_tabs.dart';
import 'package_card.dart';

class PackagesViewBody extends StatelessWidget {
  const PackagesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PackagesCubit, PackagesStates>(
      listener: (context, state) {
        if (state is SubscribePackageSuccessState) {
          Toast.showSuccessToast(
            msg: state.message.isNotEmpty
                ? state.message
                : "تم الاشتراك بنجاح",
            context: context,
          );
        } else if (state is SubscribePackageErrorState) {
          Toast.showErrorToast(msg: state.error, context: context);
        }
      },
      builder: (context, state) {
        final cubit = PackagesCubit.get(context);
        if (state is GetPackagesLoadingState) {
          return const CustomLoading();
        }
        if (state is GetPackagesErrorState) {
          return CustomErrorWidget(
            error: state.error,
            onTap: () => cubit.getPackages(),
          );
        }
        final packages = cubit.filteredPackages;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The four duration tabs side by side.
              const DurationTabs(),
              const SizedBox(height: 16),
              if (packages.isEmpty)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.card_membership_outlined,
                          size: 64,
                          color: Color(0xffD9DEE3),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "لا يوجد باقات لهذه المدة",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xff1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: packages.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) => PackageCard(
                      package: packages[index],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
