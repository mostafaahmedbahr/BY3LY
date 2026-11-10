import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/features/compare/presentation/view_model/compare_cubit.dart';
import 'package:by3ly/features/compare/presentation/view_model/compare_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'compare_widgets/comparison_table.dart';
import 'compare_widgets/empty_basket.dart';

class CompareViewBody extends StatefulWidget {
  const CompareViewBody({super.key});

  @override
  State<CompareViewBody> createState() => _CompareViewBodyState();
}

class _CompareViewBodyState extends State<CompareViewBody> {
  @override
  void initState() {
    super.initState();
    // Fetch as soon as the page opens (basket already holds 2 ids).
    CompareCubit.get(context).fetchComparison();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompareCubit, CompareStates>(
      builder: (context, state) {
        final cubit = CompareCubit.get(context);

        // No products and nothing to show: empty prompt.
        if (cubit.basketIds.isEmpty &&
            cubit.compareModel?.data?.products == null) {
          return EmptyBasket(onBrowse: () => Navigator.pop(context));
        }

        // Loading state before any data has arrived: shimmer rows.
        if (state is CompareProductsLoading &&
            cubit.compareModel?.data?.products == null) {
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
            itemCount: 6,
            itemBuilder: (context, _) =>
                const SimmerLoading(height: 56, raduis: 14),
            separatorBuilder: (context, _) => const SizedBox(height: 12),
          );
        }

        // Terminal error state with no cached data: error widget + retry.
        if (state is CompareProductsError &&
            cubit.compareModel?.data?.products == null) {
          return CustomErrorWidget(
            error: state.message,
            onTap: () => cubit.fetchComparison(),
          );
        }

        // Keep only products still in the basket: removing one via X
        // leaves the other visible with an empty slot beside it.
        final all = cubit.compareModel?.data?.products ?? [];
        final products = all
            .where((p) => cubit.basketIds.contains(p.id))
            .toList();
        if (products.isEmpty) {
          return EmptyBasket(onBrowse: () => Navigator.pop(context));
        }
        return ComparisonTable(items: products);
      },
    );
  }
}
