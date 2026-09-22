import 'package:flutter/material.dart';
import '../../../../../core/shared_widgets/custom_sized_box.dart';
import '../../../../../core/shared_widgets/shimmer_loading.dart';

class GetAllCategoriesLoadingList extends StatelessWidget {
  const GetAllCategoriesLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
      child: ListView.separated(
        itemCount: 20,
        itemBuilder: (context, index) {
          return const SimmerLoading(
            height: 56,
          );
        },
        separatorBuilder: (context, index) {
          return const CustomSizedBox(
            height: 10,
          );
        },
      ),
    );
  }
}
