import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_cubit.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Rating section inside the product details page.
///
/// Lets the user pick stars + write a comment, then POSTs
/// `{product_id, rate, commenet}` to the rateProduct endpoint.
class RateProductWidget extends StatefulWidget {
  const RateProductWidget({
    super.key,
    required this.productId,
    required this.type,
    this.currentRate,
    this.reviewsCount,
  });

  final int productId;
  final String type;
  final int? currentRate;
  final int? reviewsCount;

  @override
  State<RateProductWidget> createState() => _RateProductWidgetState();
}

class _RateProductWidgetState extends State<RateProductWidget> {
  bool _expanded = false;
  double _stars = 0;
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_stars < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr(LocaleKeys.pleaseSelectStars))),
      );
      return;
    }
    ProductDetailsCubit.get(context).rateProduct(
      productId: widget.productId,
      rate: _stars.toInt(),
      commenet: _commentController.text.trim(),
      type: widget.type,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsCubit, ProductDetailsStates>(
      listener: (context, state) {
        if (state is RateProductSuccessState) {
          Toast.showSuccessToast(
            msg: (state.message?.trim().isNotEmpty ?? false)
                ? state.message!
                : context.tr(LocaleKeys.submitRating),
            context: context,
          );
          setState(() {
            _stars = 0;
            _commentController.clear();
            _expanded = false;
          });
        } else if (state is RateProductErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        final loading = state is RateProductLoadingState;
        return Container(
          padding: const EdgeInsets.all(14),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.tr(LocaleKeys.rateProduct),
                        style: AppStyles.textStyle16W600Black,
                      ),
                    ),
                    if (widget.currentRate != null)
                      Container(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFF8E6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 15,
                              color: AppColors.yellowColor,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${widget.currentRate}'
                              '${widget.reviewsCount != null ? ' (${widget.reviewsCount})' : ''}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1F2937),
                              ),
                            ),
                          ],
                        ),
                      ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.mainColor,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: RatingBar(
                        filledIcon: Icons.star_rounded,
                        emptyIcon: Icons.star_outline_rounded,
                        initialRating: _stars,
                        maxRating: 5,
                        size: 38,
                        filledColor: AppColors.yellowColor,
                        emptyColor: const Color(0xFFD9DEE3),
                        onRatingChanged: (value) =>
                            setState(() => _stars = value),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      controller: _commentController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      hintText: context.tr(LocaleKeys.yourComment),
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      btnText: loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              context.tr(LocaleKeys.submitRating),
                              style: AppStyles.textStyle14W500White,
                            ),
                      onPressed: loading ? () {} : _submit,
                    ),
                  ],
                ),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),
            ],
          ),
        );
      },
    );
  }
}
