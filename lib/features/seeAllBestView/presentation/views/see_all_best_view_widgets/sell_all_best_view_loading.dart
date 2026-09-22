import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';

class SellAllBestViewLoading extends StatelessWidget {
  const SellAllBestViewLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child:  GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.7,
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return const SimmerLoading(
            height: 120,
            raduis: 10,
          );
        },
      ),
    );
  }
}
