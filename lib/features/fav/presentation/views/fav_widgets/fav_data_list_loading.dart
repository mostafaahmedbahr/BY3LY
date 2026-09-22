import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../../core/shared_widgets/custom_sized_box.dart';

class FavDataListLoading extends StatelessWidget {
  const FavDataListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 800),
            child: const SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: SimmerLoading(
                  height: 120,
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
  }
}
