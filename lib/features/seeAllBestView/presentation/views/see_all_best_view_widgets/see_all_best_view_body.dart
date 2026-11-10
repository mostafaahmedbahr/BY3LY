import 'package:flutter/material.dart';

import 'see_all_best_view_body_list.dart';

/// Most-viewed ads grid with a local search box.
class SeeAllBestViewBody extends StatelessWidget {
  const SeeAllBestViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: SeeAllBestViewBodyList(),
    );
  }
}
