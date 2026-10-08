import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';

/// Shimmer skeleton mirroring [NotificationsListItem].
class NotificationsLoading extends StatelessWidget {
  const NotificationsLoading({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromRGBO(248, 248, 248, 1),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimmerLoading(height: 40, width: 40, raduis: 20),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SimmerLoading(height: 13, raduis: 6),
                  SizedBox(height: 6),
                  SimmerLoading(height: 11, raduis: 6),
                  SizedBox(height: 6),
                  SimmerLoading(height: 10, width: 90, raduis: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
