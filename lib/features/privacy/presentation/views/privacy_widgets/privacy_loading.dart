import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';

/// Premium skeleton for the privacy settings page (cards + lines).
class PrivacyLoading extends StatelessWidget {
  const PrivacyLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SimmerLoading(height: 82, raduis: 18),
          SizedBox(height: 22),
          SimmerLoading(height: 16, width: 160, raduis: 6),
          SizedBox(height: 12),
          Row(
            children: [
              SimmerLoading(height: 36, width: 110, raduis: 22),
              SizedBox(width: 8),
              SimmerLoading(height: 36, width: 110, raduis: 22),
              SizedBox(width: 8),
              SimmerLoading(height: 36, width: 90, raduis: 22),
            ],
          ),
          SizedBox(height: 22),
          SimmerLoading(height: 16, width: 140, raduis: 6),
          SizedBox(height: 12),
          SimmerLoading(height: 48, raduis: 14),
          SizedBox(height: 22),
          SimmerLoading(height: 58, raduis: 16),
          SizedBox(height: 40),
          SimmerLoading(height: 52, raduis: 14),
        ],
      ),
    );
  }
}
