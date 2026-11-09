import 'dart:io';

import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_cubit.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Horizontal 1..5 premium images picker: existing network images in
/// edit mode, freshly picked file images, then the gradient add tile.
class ImagesPicker extends StatelessWidget {
  const ImagesPicker({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewAdCubit, AddNewAdStates>(
      builder: (context, state) {
        final cubit = AddNewAdCubit.get(context);
        return SizedBox(
          height: 108,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cubit.existingImages.length +
                cubit.images.length +
                1,
            separatorBuilder: (context, _) =>
                const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final existingCount = cubit.existingImages.length;
              if (index < existingCount) {
                final url = cubit.existingImages[index];
                return _ImageTile(
                  index: index,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      url,
                      width: 104,
                      height: 104,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 104,
                        height: 104,
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),
                  onRemove: () => cubit.removeExistingImage(index),
                );
              }
              final fileIndex = index - existingCount;
              if (fileIndex < cubit.images.length) {
                final file = cubit.images[fileIndex];
                return _ImageTile(
                  index: index,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(file.path),
                      width: 104,
                      height: 104,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onRemove: () => cubit.removeImage(fileIndex),
                );
              }
              return _AddTile(
                current: cubit.totalImagesCount,
                max: AddNewAdCubit.maxImages,
                enabled:
                    cubit.totalImagesCount < AddNewAdCubit.maxImages,
                onTap: onAdd,
              );
            },
          ),
        );
      },
    );
  }
}

/// One picked image with a remove badge and order number.
class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.index,
    required this.child,
    required this.onRemove,
  });

  final int index;
  final Widget child;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: child,
        ),
        Positioned(
          top: -7,
          right: -7,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffE53935),
                      Color(0xffB71C1C),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.45),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 7,
          left: 7,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xffFAB043),
                  Color(0xffF5B301),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffFAB043)
                      .withValues(alpha: 0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Color(0xff3D2B00),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Gradient add tile showing the current usage counter.
class _AddTile extends StatelessWidget {
  const _AddTile({
    required this.current,
    required this.max,
    required this.enabled,
    required this.onTap,
  });

  final int current;
  final int max;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        child: Opacity(
          opacity: enabled ? 1 : 0.45,
          child: Container(
            width: 104,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.mainColor.withValues(alpha: 0.10),
                  AppColors.mainColor.withValues(alpha: 0.02),
                ],
              ),
              border: Border.all(
                color: AppColors.mainColor.withValues(alpha: 0.45),
                width: 1.4,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  color: AppColors.mainColor,
                  size: 28,
                ),
                const SizedBox(height: 6),
                Text(
                  '$current/$max',
                  style: const TextStyle(
                    color: AppColors.mainColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
