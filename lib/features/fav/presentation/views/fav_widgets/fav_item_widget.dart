import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/product_cards.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/features/fav/data/models/fav_model.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FavItemWidget extends StatelessWidget {
  const FavItemWidget({super.key, required this.favourite});
  final Favourites favourite;
  @override
  Widget build(BuildContext context) {
    return ProductRowCard(
      imageUrl: favourite.image ?? '',
      title: favourite.name ?? '',
      location: favourite.address,
      type: favourite.type,
      model: favourite.model,
      price: favourite.price,
      date: favourite.createdAt,
      productId: favourite.id,
      initialIsFavourite: true,
      bottomWidget: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: InkWell(
          onTap: () {
            if (favourite.id != null) {
              FavCubit.get(context)
                  .removeProductFromFav(productId: favourite.id!);
            }
          },
          child: Text(
            LocaleKeys.removerFromFav.tr(),
            style: AppStyles.textStyle12W600Gary.copyWith(
              color: AppColors.redColor,
            ),
          ),
        ),
      ),
      onTap: () {
        context.pushNamed(Routes.productDetailsView, arguments: {
          "type": "home",
          "productId": favourite.id ?? 0,
        });
      },
    );
  }
}
