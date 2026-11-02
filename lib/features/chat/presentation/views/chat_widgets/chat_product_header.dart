import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../data/models/chat_models.dart';

class ChatProductHeader extends StatelessWidget {
  const ChatProductHeader({super.key, required this.product});

  final ChatProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: product.id == null
          ? null
          : () => context.pushNamed(
              Routes.productDetailsView,
              arguments: {'productId': product.id, 'type': 'home'},
            ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 48,
                width: 48,
                child: CustomNetWorkImage(
                  imageUrl: product.image ?? '',
                  raduis: 10,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.priceLabel.isEmpty
                        ? ''
                        : '${product.priceLabel} ${context.tr(LocaleKeys.currencyEgp)}',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
