import 'package:by3ly/features/PaymentBalance/presentation/views/payment_and_balance_view.dart';
import 'package:by3ly/features/profile/presentation/views/profile_widgets/profile_view_body_list_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../core/utils/app_images/app_images.dart';
import '../../../../../lang/locale_keys.dart';
import '../../../../fav/presentation/views/fav_view.dart';
 import '../../../../helpSupport/presentation/views/help_support_view.dart';
import '../../../../statistics/presentation/views/statistics_view.dart';

class ProfileListItemsWidgets extends StatelessWidget {
  const ProfileListItemsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileViewBodyListItemWidget(
          svg: true,
          onTap: (){
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const PaymentAndBalanceView(),
              ),
            );
          },
          title: context.tr(LocaleKeys.paymentAndBalance),
          image: AppImages.wallet,
        ),
        ProfileViewBodyListItemWidget(
          svg: true,
          onTap: (){
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const FavView(),
              ),
            );
          },
          title:  LocaleKeys.favorite.tr(),
          image: AppImages.heart,
        ),
        ProfileViewBodyListItemWidget(
          svg: true,
          onTap: (){
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const StatisticsView(),
              ),
            );
          },
          title: LocaleKeys.statistics.tr(),
          image: AppImages.chart,
        ),
        ProfileViewBodyListItemWidget(
          svg: true,
          onTap: (){
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const HelpSupportView(),
              ),
            );
          },
          title: LocaleKeys.reportingAndSupport.tr(),
          image: AppImages.bullhorn,
        ),
      ],
    );
  }
}
