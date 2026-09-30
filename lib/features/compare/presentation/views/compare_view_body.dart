import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/features/compare/data/models/compare_model.dart';
import 'package:by3ly/features/compare/presentation/view_model/compare_cubit.dart';
import 'package:by3ly/features/compare/presentation/view_model/compare_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompareViewBody extends StatefulWidget {
  const CompareViewBody({super.key});

  @override
  State<CompareViewBody> createState() => _CompareViewBodyState();
}

class _CompareViewBodyState extends State<CompareViewBody> {
  @override
  void initState() {
    super.initState();
    // Fetch as soon as the page opens (basket already holds 2 ids).
    CompareCubit.get(context).fetchComparison();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompareCubit, CompareStates>(
      builder: (context, state) {
        final cubit = CompareCubit.get(context);

        if (cubit.basketIds.isEmpty &&
            cubit.compareModel?.data?.products == null) {
          return _EmptyBasket(
            onBrowse: () => Navigator.pop(context),
          );
        }

        if (state is CompareProductsLoading &&
            cubit.compareModel?.data?.products == null) {
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: 6,
            itemBuilder: (context, _) =>
                const SimmerLoading(height: 64, raduis: 12),
            separatorBuilder: (context, _) => const SizedBox(height: 10),
          );
        }

        if (state is CompareProductsError &&
            cubit.compareModel?.data?.products == null) {
          return CustomErrorWidget(
            error: state.message,
            onTap: () => cubit.fetchComparison(),
          );
        }

        // Keep only products still in the basket: removing one via X
        // leaves the other visible with an empty slot beside it.
        final all = cubit.compareModel?.data?.products ?? [];
        final products = all
            .where((p) => cubit.basketIds.contains(p.id))
            .toList();
        if (products.isEmpty) {
          return _EmptyBasket(
            onBrowse: () => Navigator.pop(context),
          );
        }
        return _ComparisonTable(items: products);
      },
    );
  }
}

class _EmptyBasket extends StatelessWidget {
  const _EmptyBasket({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.compare_arrows_rounded,
              size: 72,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              context.tr(LocaleKeys.pickSecondProduct),
              textAlign: TextAlign.center,
              style: AppStyles.textStyle14W500White.copyWith(
                color: AppColors.greyColor,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onBrowse,
              child: Text(
                context.tr(LocaleKeys.back),
                style: const TextStyle(color: AppColors.mainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({required this.items});

  /// 1 or 2 products. With a single product an empty slot is shown
  /// beside it so the user can pick another one.
  final List<CompareProduct> items;

  @override
  Widget build(BuildContext context) {
    final first = items[0];
    final second = items.length > 1 ? items[1] : null;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _ProductHeader(product: first)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 40),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.mainColor,
                shape: BoxShape.circle,
              ),
              child: const Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              child: second != null
                  ? _ProductHeader(product: second)
                  : const _EmptySlot(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SpecCard(rows: [
          _SpecRowData(
            label: context.tr(LocaleKeys.price),
            first: _withCurrency(first),
            second: second != null ? _withCurrency(second) : '',
            highlight: true,
          ),
          if (_has(first.oldPrice) ||
              (second != null && _has(second.oldPrice)))
            _SpecRowData(
              label: context.tr(LocaleKeys.oldPrice),
              first: _withCurrencyOld(first),
              second: second != null ? _withCurrencyOld(second) : '',
              strikethrough: true,
            ),
          _SpecRowData(
            label: context.tr(LocaleKeys.type),
            first: first.type ?? '-',
            second: second?.type ?? '',
          ),
          _SpecRowData(
            label: 'Model',
            first: first.model ?? '-',
            second: second?.model ?? '',
          ),
          _SpecRowData(
            label: 'Marka',
            first: first.marka ?? '-',
            second: second?.marka ?? '',
          ),
          _SpecRowData(
            label: context.tr(LocaleKeys.place),
            first: first.location ?? '-',
            second: second?.location ?? '',
          ),
          _SpecRowData(
            label: context.tr(LocaleKeys.rating),
            first: _withReviews(first),
            second: second != null ? _withReviews(second) : '',
          ),
          _SpecRowData(
            label: context.tr(LocaleKeys.dateAdded),
            first: first.date ?? first.createdAt ?? '-',
            second: second?.date ?? second?.createdAt ?? '',
          ),
        ]),
        if (_has(first.desc) ||
            (second != null && _has(second.desc))) ...[
          const SizedBox(height: 16),
          _DescCard(first: first, second: second),
        ],
      ],
    );
  }

  bool _has(String? v) => v?.trim().isNotEmpty ?? false;

  String _withCurrency(CompareProduct p) {
    final price = p.price ?? '-';
    if (price == '-' || (p.currency?.trim().isEmpty ?? true)) return price;
    return '$price ${p.currency}';
  }

  String _withCurrencyOld(CompareProduct p) {
    final price = p.oldPrice ?? '-';
    if (price == '-' || (p.currency?.trim().isEmpty ?? true)) return price;
    return '$price ${p.currency}';
  }

  String _withReviews(CompareProduct p) {
    final rate = p.rate ?? '-';
    if (rate == '-') return rate;
    if (p.reviewsCount != null) return '$rate (${p.reviewsCount})';
    return rate;
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.mainColor.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.mainColor,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                context.tr(LocaleKeys.pickSecondProduct),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.greyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductHeader extends StatelessWidget {
  const _ProductHeader({required this.product});

  final CompareProduct product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (product.id != null) {
          context.pushNamed(Routes.productDetailsView, arguments: {
            "type": "home",
            "productId": product.id!,
          });
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0F0F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                CustomNetWorkImage(
                  imageUrl: product.image ?? '',
                  raduis: 12,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 110,
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: InkWell(
                    onTap: () =>
                        CompareCubit.get(context).removeFromBasket(
                      product.id ?? -1,
                    ),
                    child: Container(
                      height: 26,
                      width: 26,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: AppColors.redColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              product.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xff1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecRowData {
  final String label;
  final String first;
  final String second;
  final bool highlight;
  final bool strikethrough;

  const _SpecRowData({
    required this.label,
    required this.first,
    required this.second,
    this.highlight = false,
    this.strikethrough = false,
  });
}

class _SpecCard extends StatelessWidget {
  const _SpecCard({required this.rows});

  final List<_SpecRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              child: Column(
                children: [
                  Text(
                    rows[i].label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xff9AA0A6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (rows[i].second.isEmpty)
                    // Single product: full-width value.
                    Text(
                      rows[i].first,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: rows[i].highlight ? 15 : 13,
                        fontWeight: rows[i].highlight
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: rows[i].highlight
                            ? AppColors.mainColor
                            : const Color(0xff1F2937),
                        decoration: rows[i].strikethrough
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            rows[i].first,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: rows[i].highlight ? 15 : 13,
                              fontWeight: rows[i].highlight
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              color: rows[i].highlight
                                  ? AppColors.mainColor
                                  : const Color(0xff1F2937),
                              decoration: rows[i].strikethrough
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          color: const Color(0xFFF0F0F0),
                        ),
                        Expanded(
                          child: Text(
                            rows[i].second,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: rows[i].highlight ? 15 : 13,
                              fontWeight: rows[i].highlight
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              color: rows[i].highlight
                                  ? AppColors.mainColor
                                  : const Color(0xff1F2937),
                              decoration: rows[i].strikethrough
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (i != rows.length - 1)
              const Divider(height: 1, color: Color(0xFFF0F0F0)),
          ],
        ],
      ),
    );
  }
}

class _DescCard extends StatelessWidget {
  const _DescCard({required this.first, this.second});

  final CompareProduct first;
  final CompareProduct? second;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr(LocaleKeys.descriptionLabel),
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xff9AA0A6),
            ),
          ),
          const SizedBox(height: 8),
          if (second == null)
            Text(
              (first.desc?.trim().isNotEmpty ?? false)
                  ? first.desc!
                  : '-',
              textAlign: TextAlign.center,
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Color(0xff1F2937),
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    (first.desc?.trim().isNotEmpty ?? false)
                        ? first.desc!
                        : '-',
                    textAlign: TextAlign.center,
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: Color(0xff1F2937),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: const Color(0xFFF0F0F0),
                ),
                Expanded(
                  child: Text(
                    (second!.desc?.trim().isNotEmpty ?? false)
                        ? second!.desc!
                        : '-',
                    textAlign: TextAlign.center,
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: Color(0xff1F2937),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
