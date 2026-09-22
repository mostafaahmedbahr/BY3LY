 import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
 import 'package:flutter/material.dart';

class CommonQuestionsWidget extends StatelessWidget {
  const CommonQuestionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
    final GlobalKey<ExpansionTileCardState> cardB = GlobalKey();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(LocaleKeys.commonQuestions.tr(),
        style: AppStyles.textStyle16W500Black,),
        const SizedBox(height: 20,),
        ExpansionTileCard(
          key: cardA,
          title:   Text(LocaleKeys.howBuyOperationDone.tr()),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  """بيعلي غير مسؤول عن اي عمليه ماليه تحدث بين المشتري والبائع نحن لسنا الا مجرد منصه لوصل المشتري بالبائع.

ليست كل المنتجات قابله للفصال او تقديم عروض للسعر فهناك منتجات  باسعار ثابته.

 بعد ان تتم عملية الدفع ارسل الايصال الي البائع لتاكيد عمليه الدفع""",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20,),
        ExpansionTileCard(
          key: cardB,
          title:   Text(context.tr(LocaleKeys.howIsTheSaleProcess)),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  """بيعلي غير مسؤول عن اي عمليه ماليه تحدث بين المشتري والبائع نحن لسنا الا مجرد منصه لوصل المشتري بالبائع.

ليست كل المنتجات قابله للفصال او تقديم عروض للسعر فهناك منتجات  باسعار ثابته.

 بعد ان تتم عملية الدفع ارسل الايصال الي البائع لتاكيد عمليه الدفع""",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 16),
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }
}
