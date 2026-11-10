import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/compare_model.dart';
import 'desc_card.dart';
import 'empty_slot.dart';
import 'product_header.dart';
import 'spec_card.dart';
import 'spec_row_data.dart';

class _FieldRow {
  const _FieldRow({
    required this.label,
    required this.first,
    required this.second,
    this.highlight = false,
    this.strikethrough = false,
  });

  final String label;

  /// Raw value of the first product — null when it has none.
  final String? first;

  /// Raw value of the second product — null when it has none (or when there
  /// is only one product in the comparison).
  final String? second;

  final bool highlight;
  final bool strikethrough;
}

/// Vertical scroll with the side-by-side comparison: product headers on top,
/// spec table below, optional description cards underneath.
///
/// Every row in the spec table is built dynamically from the products'
/// own data — rows with no value on either side are dropped completely,
/// and every field the server sends (price, discount, seller, views ...)
/// is shown as long as it carries a value.
class ComparisonTable extends StatelessWidget {
  const ComparisonTable({super.key, required this.items});

  /// 1 or 2 products. With a single product an empty slot is shown
  /// beside it so the user can pick another one.
  final List<CompareProduct> items;

  bool _has(String? v) => v?.trim().isNotEmpty ?? false;

  String? _str(String? v) {
    final t = v?.trim() ?? '';
    return t.isEmpty ? null : t;
  }

  /// Normalizes `old_price` (dynamic — num or string from the API) to a
  /// trimmed string, dropping trailing ".0" and whitespace.
  String? _strNum(dynamic v) {
    if (v == null) return null;
    if (v is num) {
      final d = v.toDouble();
      return d == d.truncateToDouble()
          ? d.toInt().toString()
          : d.toString();
    }
    return _str(v.toString());
  }

  /// Appends the product's currency to a raw price string when present.
  String? _money(CompareProduct p, String? raw) {
    if (raw == null) return null;
    final currency = _str(p.currency);
    return currency == null ? raw : '$raw $currency';
  }

  /// "rate (reviews)" — same shape used on the product cards.
  String? _rating(CompareProduct p) {
    final rate = _str(p.rate);
    if (rate == null) return null;
    if (p.reviewsCount != null) return '$rate (${p.reviewsCount})';
    return rate;
  }

  String? _yesNo(BuildContext context, bool? v) => v == null
      ? null
      : (v ? context.tr(LocaleKeys.yes) : context.tr(LocaleKeys.no));

  bool _finalDiffersFromPrice(CompareProduct p) {
    final finalPrice = p.finalPrice;
    if (finalPrice == null) return false;
    final raw = p.price?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '';
    final price = double.tryParse(raw);
    // No comparable price on this side — final price is all that exists.
    if (price == null) return true;
    return price != finalPrice;
  }

  /// Builds every row whose value exists on at least one side.
  List<_FieldRow> _buildEntries(
    BuildContext context,
    CompareProduct first,
    CompareProduct? second,
  ) {
    final entries = <_FieldRow>[];

    void add(
      String label,
      String? a,
      String? b, {
      bool highlight = false,
      bool strikethrough = false,
    }) {
      // Drop the row entirely when neither product carries a value for it.
      if (a == null && b == null) return;
      entries.add(
        _FieldRow(
          label: label,
          first: a,
          second: b,
          highlight: highlight,
          strikethrough: strikethrough,
        ),
      );
    }

    String? moneyOf(CompareProduct p, String? raw, bool Function(CompareProduct) include) =>
        include(p) ? _money(p, raw) : null;

    add(
      context.tr(LocaleKeys.price),
      _money(first, _str(first.price)),
      second == null ? null : _money(second, _str(second.price)),
      highlight: true,
    );
    add(
      context.tr(LocaleKeys.oldPrice),
      _money(first, _strNum(first.oldPrice)),
      second == null
          ? null
          : _money(second, _strNum(second.oldPrice)),
      strikethrough: true,
    );
    add(
      context.tr(LocaleKeys.finalPriceLabel),
      moneyOf(
        first,
        _strNum(first.finalPrice),
        _finalDiffersFromPrice,
      ),
      second == null
          ? null
          : moneyOf(
              second,
              _strNum(second.finalPrice),
              _finalDiffersFromPrice,
            ),
    );
    add(
      context.tr(LocaleKeys.discountLabel),
      first.discount != null && first.discount! > 0
          ? '${first.discount}%'
          : null,
      second == null
          ? null
          : (second.discount != null && second.discount! > 0
              ? '${second.discount}%'
              : null),
    );
    add(
      context.tr(LocaleKeys.type),
      _str(first.type),
      second == null ? null : _str(second.type),
    );
    add(
      context.tr(LocaleKeys.modelLabel),
      _str(first.model),
      second == null ? null : _str(second.model),
    );
    add(
      context.tr(LocaleKeys.markaLabel),
      _str(first.marka),
      second == null ? null : _str(second.marka),
    );
    add(
      context.tr(LocaleKeys.place),
      _str(first.location),
      second == null ? null : _str(second.location),
    );
    add(
      context.tr(LocaleKeys.subCategory),
      _str(first.subCategory),
      second == null ? null : _str(second.subCategory),
    );
    add(
      context.tr(LocaleKeys.furnishingLabel),
      _str(first.furnishingLabel?.toString()) ?? _strNum(first.furnishing),
      second == null
          ? null
          : _str(second.furnishingLabel?.toString()) ??
              _strNum(second.furnishing),
    );
    add(
      context.tr(LocaleKeys.rating),
      _rating(first),
      second == null ? null : _rating(second),
    );
    add(
      context.tr(LocaleKeys.sellerLabel),
      _str(first.seller?.name),
      second == null ? null : _str(second.seller?.name),
    );
    add(
      context.tr(LocaleKeys.sellerRatingLabel),
      first.seller?.rating == null
          ? null
          : (first.seller?.reviewsCount == null
              ? '${first.seller!.rating}'
              : '${first.seller!.rating} (${first.seller!.reviewsCount})'),
      second == null
          ? null
          : (second.seller?.rating == null
              ? null
              : (second.seller?.reviewsCount == null
                  ? '${second.seller!.rating}'
                  : '${second.seller!.rating} (${second.seller!.reviewsCount})')),
    );
    add(
      context.tr(LocaleKeys.views),
      (first.views ?? 0) > 0 ? '${first.views}' : null,
      second == null
          ? null
          : ((second.views ?? 0) > 0 ? '${second.views}' : null),
    );
    add(
      context.tr(LocaleKeys.commentsCountLabel),
      (first.countCommenets ?? 0) > 0 ? '${first.countCommenets}' : null,
      second == null
          ? null
          : ((second.countCommenets ?? 0) > 0
              ? '${second.countCommenets}'
              : null),
    );
    add(
      context.tr(LocaleKeys.isNegotiableLabel),
      _yesNo(context, first.isNegotiable),
      second == null ? null : _yesNo(context, second.isNegotiable),
    );
    add(
      context.tr(LocaleKeys.urgent),
      _yesNo(context, first.isUrgent),
      second == null ? null : _yesNo(context, second.isUrgent),
    );
    add(
      context.tr(LocaleKeys.dateAdded),
      _str(first.date ?? first.createdAt),
      second == null
          ? null
          : _str(second.date ?? second.createdAt),
    );

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final first = items[0];
    final second = items.length > 1 ? items[1] : null;

    final rows = _buildEntries(context, first, second)
        .map(
          (e) => SpecRowData(
            label: e.label,
            first: e.first ?? '-',
            second: second != null ? (e.second ?? '-') : '',
            highlight: e.highlight,
            strikethrough: e.strikethrough,
          ),
        )
        .toList();

    final hasDescription = _has(first.desc) ||
        (second != null && _has(second.desc));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: ProductHeader(product: first)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: const BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: const Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            Expanded(
              child: second != null
                  ? ProductHeader(product: second)
                  : const EmptySlot(),
            ),
          ],
        ),
        if (rows.isNotEmpty) ...[
          const SizedBox(height: 16),
          SpecCard(rows: rows),
        ],
        if (hasDescription) ...[
          const SizedBox(height: 16),
          DescCard(first: first, second: second),
        ],
        if (rows.isEmpty && !hasDescription) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              context.tr(LocaleKeys.noCompareValues),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
