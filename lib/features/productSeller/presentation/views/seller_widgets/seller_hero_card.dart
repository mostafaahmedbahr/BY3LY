import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:by3ly/features/productSeller/data/models/product_seller_model.dart';
import 'package:flutter/material.dart';

import '../../../../../features/chat/presentation/views/chat_widgets/start_chat_button.dart';
import '../../../../../features/profile/presentation/view_model/profile_cubit.dart';

/// Premium seller hero — identity panel spanning the top of the page:
/// big logo-avatar with a gold verified badge, name, rating chip, and
/// a gold-gradient "contact now" CTA (hidden when viewing own profile).
class SellerHeroCard extends StatelessWidget {
  const SellerHeroCard({super.key, required this.seller, required this.sellerId});

  final Seller seller;
  final int sellerId;

  bool _isOwn(BuildContext context) {
    try {
      return ProfileCubit.get(context).profileModel?.data?.user?.id == sellerId;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOwn = _isOwn(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkMainColor,
            AppColors.mainColor,
            AppColors.secondColor,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with gold verified ring.
          SizedBox(
            height: 76,
            width: 76,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipOval(
                  child: CustomNetWorkImage(
                    imageUrl: seller.image ?? '',
                    raduis: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.yellowColor,
                      width: 2.4,
                    ),
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.yellowColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_rounded,
                      size: 11,
                      color: Color(0xff1A1205),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Name + rating chip (+ contact CTA hidden for own profile).
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  seller.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.1,
                    height: 1.2,
                  ),
                ),
                if (seller.rating != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.yellowColor,
                        size: 16,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${seller.rating}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (seller.reviewsCount != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '(${seller.reviewsCount})',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.72),
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (!isOwn) ...[
            const SizedBox(width: 6),
            StartChatButton(
              userId: sellerId,
              builder: (context, isLoading, onPressed) => SizedBox(
                height: 46,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.yellowColor,
                        Color(0xffE08B1B),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.yellowColor
                            .withValues(alpha: 0.40),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isLoading ? null : onPressed,
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Color(0xff1A1205),
                                ),
                              )
                            : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.chat_outlined,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      LocaleKeys.contactNow.tr(),
                                      style: const TextStyle(
                                        color: Color(0xff1A1205),
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
