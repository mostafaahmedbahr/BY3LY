import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';

/// Full-page skeleton: hero panel + tab row + info lines + list rows.
class SellerShimmer extends StatelessWidget {
  const SellerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SimmerLoading(height: 108, raduis: 22),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: SimmerLoading(height: 44, raduis: 14)),
              SizedBox(width: 8),
              Expanded(child: SimmerLoading(height: 44, raduis: 14)),
              SizedBox(width: 8),
              Expanded(child: SimmerLoading(height: 44, raduis: 14)),
            ],
          ),
          SizedBox(height: 16),
          SimmerLoading(height: 88, raduis: 18),
          SizedBox(height: 12),
          SimmerLoading(height: 88, raduis: 18),
        ],
      ),
    );
  }
}
