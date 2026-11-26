import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../data/models/home_model.dart';
import '../../../../seeAllBestView/presentation/views/see_all_best_view.dart';
import 'best_view_products_list.dart';
import 'section_header.dart';

/// Best-of section emitted as slivers so the parent CustomScrollView can keep
/// the grid lazy. Padding/spacing match the old Padding + Column version.
class BestViewProducts extends StatelessWidget {
  const BestViewProducts({super.key, required this.bestView});

  final List<BestView> bestView;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 20),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              SectionHeader(
                title: context.tr(LocaleKeys.bestView),
                actionLabel: context.tr(LocaleKeys.seeAll),
                onAction: () => Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const SeeAllView(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: BestViewProductsList(bestView: bestView),
          ),
        ],
      ),
    );
  }
}
