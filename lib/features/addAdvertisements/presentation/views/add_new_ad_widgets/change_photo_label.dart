import 'package:flutter/material.dart';

/// Small dark label over the attached receipt image ("تغيير الصورة").
class ChangePhotoLabel extends StatelessWidget {
  const ChangePhotoLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'تغيير الصورة',
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
    );
  }
}
