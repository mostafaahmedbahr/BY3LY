import 'package:by3ly/core/extensions/lang.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_cubit.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_states.dart';
import 'package:by3ly/features/allSubCategories/presentation/view_model/all_sub_categories_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ad_payment_sheet.dart';
import 'add_new_ad_helpers.dart';
import 'category_dropdown.dart';
import 'center_dropdown.dart';
import 'chips_row.dart';
import 'city_dropdown.dart';
import 'form_card.dart';
import 'image_source_sheet.dart';
import 'images_picker.dart';
import 'premium_cta_button.dart';
import 'premium_hero_header.dart';
import 'premium_step_indicator.dart';
import 'sub_category_dropdown.dart';
import 'switch_row.dart';

/// Body of the add / edit ad screen.
///
/// Wizard layout: a compact hero with a live completion percentage, a
/// 5-step indicator, the current step's card(s), and a pinned bottom bar
/// (Back ghost button + gradient Continue / Publish action).
///
/// The ad is passed as `dynamic` on purpose: both the legacy ads model
/// and the current one work with the same loose getters.
class AddNewAdViewBody extends StatefulWidget {
  const AddNewAdViewBody({super.key, this.adToEdit});

  final dynamic adToEdit;

  @override
  State<AddNewAdViewBody> createState() => _AddNewAdViewBodyState();
}

class _AddNewAdViewBodyState extends State<AddNewAdViewBody> {
  static const int _stepCount = 6;

  /// Current wizard step (0..4).
  int _currentStep = 0;

  /// Direction of the last navigation for the step transition.
  int _stepDirection = 1;

  /// True while checking whether the subscription still covers a free
  /// publish (direct publish vs payment step).
  bool _checkingPackage = false;

  /// True while the payment sheet is on screen — avoids opening it
  /// twice and routes errors to the right place.
  bool _paymentSheetOpen = false;

  /// True when the ad was published from inside the payment sheet. The
  /// page is popped with `true` only after the sheet closes so the caller
  /// (e.g. the my-ads list) knows it has to refresh.
  bool _publishedFromSheet = false;

  Future<void> _openPaymentSheet() async {
    if (_paymentSheetOpen) return;
    _paymentSheetOpen = true;
    _publishedFromSheet = false;
    await showAdPaymentSheet(context);
    _paymentSheetOpen = false;
    if (!mounted) return;
    if (_publishedFromSheet) {
      _publishedFromSheet = false;
      // The sheet has already closed, so this pops the form page and
      // returns `true` to the caller to trigger a refresh.
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();
    final cubit = AddNewAdCubit.get(context);
    final user =
        ProfileCubit.get(context).profileModel?.data?.user;
    final ad = widget.adToEdit;
    if (ad != null) {
      cubit.fillForEdit(
        adId: ad.id ?? 0,
        name: ad.name?.toString(),
        description:
            (ad.desc?.toString().trim().isNotEmpty ?? false)
                ? ad.desc?.toString()
                : ad.description?.toString(),
        price: ad.price?.toString(),
        discount: ad.discount?.toString(),
        negotiable: ad.isNegotiable == true ? 1 : 0,
        urgent: ad.isUrgent == true ? 1 : 0,
        categoryId: asIntOrNull(ad.categoryId),
        subCategoryId: asIntOrNull(ad.subCategoryId),
        shipping: ad.shippingType?.toString(),
        conditionValue: ad.condition?.toString(),
        cityIdValue: asIntOrNull(ad.cityId),
        centerIdValue: asIntOrNull(ad.centerId),
        imageUrls: [
          for (final img in (ad.images ?? []))
            if ((img?.image?.trim().isNotEmpty ?? false))
              img!.image!.trim(),
        ],
        profileCityId: asIntOrNull(user?.cityId),
        profileCenterId: asIntOrNull(user?.centerId),
      );
      // Load sub-categories of the ad's category for the dropdown.
      final catId = asIntOrNull(ad.categoryId);
      if (catId != null) {
        AllSubCategoriesCubit.get(context)
            .getAllSubCategories(categoryId: catId);
      }
    } else {
      // Default city/center = the user's own data (changeable below).
      cubit.initLocation(
        defaultCityId: asIntOrNull(user?.cityId),
        defaultCenterId: asIntOrNull(user?.centerId),
      );
    }
  }

  bool get _isLastStep => _currentStep == _stepCount - 1;

  /// Validation for the current wizard step only (publish-time validation
  /// still happens inside [_onSubmitPressed] / cubit.validate()).
  String? _stepErrorKey() {
    final cubit = AddNewAdCubit.get(context);
    switch (_currentStep) {
      case 0:
        if (cubit.categoryId == null) return 'categoryRequired';
        if (cubit.subCategoryId == null) {
          return 'subCategoryRequired';
        }
        return null;
      case 1:
        if (cubit.nameCon.text.trim().isEmpty) {
          return 'nameRequired';
        }
        if (cubit.descCon.text.trim().isEmpty) {
          return 'descRequired';
        }
        return null;
      case 2:
        final price = double.tryParse(cubit.priceCon.text.trim());
        if (price == null || price <= 0) return 'priceRequired';
        return null;
      case 3:
        if (cubit.totalImagesCount < 1) return 'imagesRequired';
        return null;
      case 4:
        return null; // shippingType & condition always have defaults
      case 5:
        if (cubit.cityId == null) return 'cityRequired';
        if (cubit.centerId == null) return 'centerRequired';
        return null;
      default:
        return null;
    }
  }

  void _goToStep(int step) {
    setState(() {
      _stepDirection = step > _currentStep ? 1 : -1;
      _currentStep = step.clamp(0, _stepCount - 1);
    });
  }

  void _goNext() {
    final error = _stepErrorKey();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(addNewAdValidationMessage(context, error))),
      );
      return;
    }
    _goToStep(_currentStep + 1);
  }

  void _goBack() => _goToStep(_currentStep - 1);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNewAdCubit, AddNewAdStates>(
      listener: (context, state) {
        if (state is AddNewAdSuccess) {
          CherryToast.success(
            title: Text(
              (state.message?.trim().isNotEmpty ?? false)
                  ? state.message!
                  : context.tr(LocaleKeys.publishAd),
              style:
                  const TextStyle(color: AppColors.mainColor),
            ),
          ).show(context);
          if (_paymentSheetOpen) {
            // The payment sheet closes itself on success; wait until it is
            // gone before popping this page (see _openPaymentSheet).
            _publishedFromSheet = true;
          } else {
            Navigator.pop(context, true);
          }
        } else if (state is AddNewAdPaymentRequired) {
          // Package/free ads exhausted → the server demands payment:
          // force the payment step instead of publishing directly.
          if (!_paymentSheetOpen) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            _openPaymentSheet();
          }
        } else if (state is AddNewAdError) {
          // When the sheet is open it toasts the error itself.
          if (!_paymentSheetOpen) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        }
      },
      builder: (context, state) {
        final cubit = AddNewAdCubit.get(context);
        final submitting = state is AddNewAdLoading;
        // Locale-based direction check (codebase idiom).
        final isRtl = context.isArabic;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.surfaceVariant.withValues(alpha: 0.55),
                AppColors.background,
              ],
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  // Not const: progress must recompute on every cubit emit.
                  child: PremiumHeroHeader(),
                ),
                PremiumStepIndicator(currentStep: _currentStep),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    transitionBuilder: (child, animation) {
                      final fade = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      );
                      return FadeTransition(
                        opacity: fade,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.04 * _stepDirection),
                            end: Offset.zero,
                          ).animate(fade),
                          child: child,
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      key: ValueKey('step_$_currentStep'),
                      padding: const EdgeInsets.fromLTRB(
                          16, 12, 16, 16),
                      child: _buildStep(context, cubit),
                    ),
                  ),
                ),
                _BottomBar(
                  showBack: _currentStep > 0,
                  isLastStep: _isLastStep,
                  isEditMode: cubit.isEditMode,
                  submitting: submitting || _checkingPackage,
                  isRtl: isRtl,
                  onBack: _goBack,
                  onNextOrSubmit: () => _isLastStep
                      ? _onSubmitPressed(context, cubit)
                      : _goNext(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Content of the active wizard step.
  Widget _buildStep(BuildContext context, AddNewAdCubit cubit) {
    switch (_currentStep) {
      // ── STEP 1 · القسم (category + sub-category) ─────────────────
      case 0:
        return FormCard(
          step: '1',
          title: context.tr(LocaleKeys.category),
          child: Column(
            children: [
              const CategoryDropdown(),
              const SizedBox(height: 12),
              const SubCategoryDropdown(),
            ],
          ),
        );

      // ── STEP 2 · البيانات الأساسية (name / description) ──────────
      case 1:
        return FormCard(
          step: '2',
          title: context.tr(LocaleKeys.adName),
          child: Column(
            children: [
              CustomTextFormField(
                controller: cubit.nameCon,
                keyboardType: TextInputType.text,
                labelText: context.tr(LocaleKeys.adName),
                onChanged: (_) => cubit.notifyFormChanged(),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.title_rounded,
                      color: AppColors.mainColor, size: 20),
                ),
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: cubit.descCon,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                labelText: context.tr(LocaleKeys.adDescription),
                onChanged: (_) => cubit.notifyFormChanged(),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.description_outlined,
                      color: AppColors.mainColor, size: 20),
                ),
              ),
            ],
          ),
        );

      // ── STEP 3 · السعر والعرض (price / discount / toggles) ───────
      case 2:
        return FormCard(
          step: '3',
          title: context.tr(LocaleKeys.priceAndOffer),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: cubit.priceCon,
                      keyboardType: TextInputType.number,
                      labelText: context.tr(LocaleKeys.adPrice),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.payments_outlined,
                            color: AppColors.mainColor,
                            size: 20),
                      ),
                      suffixIcon: cubit.discountPercentage != null
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                '-${cubit.discountPercentage!.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: AppColors.redColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : null,
                      onChanged: (_) => cubit.notifyFormChanged(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextFormField(
                      controller: cubit.discountCon,
                      keyboardType: TextInputType.number,
                      labelText:
                          context.tr(LocaleKeys.discount),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.attach_money,
                            color: AppColors.mainColor, size: 20),
                      ),
                      onChanged: (_) => cubit.notifyFormChanged(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchRow(
                title: context.tr(LocaleKeys.negotiable),
                icon: Icons.handshake_outlined,
                value: cubit.isNegotiable == 1,
                onChanged: cubit.toggleNegotiable,
              ),
              const SizedBox(height: 8),
              SwitchRow(
                title: context.tr(LocaleKeys.urgent),
                icon: Icons.bolt_outlined,
                value: cubit.isUrgent == 1,
                onChanged: cubit.toggleUrgent,
              ),
            ],
          ),
        );

      // ── STEP 4 · الصور ───────────────────────────────────────────
      case 3:
        return FormCard(
          step: '4',
          title: context.tr(LocaleKeys.selectImages),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagesPicker(
                onAdd: () => showImageSourceSheet(context, cubit),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      context.tr(LocaleKeys.imagesHint),
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      // ── STEP 5 · الشحن والحالة ───────────────────────────────────
      case 4:
        return FormCard(
          step: '5',
          title: context.tr(LocaleKeys.shippingType),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChipsRow(
                options: [
                  ChipOption(
                      value: 'free',
                      label:
                          context.tr(LocaleKeys.freeShipping)),
                  ChipOption(
                      value: 'paid',
                      label:
                          context.tr(LocaleKeys.paidShipping)),
                ],
                selected: cubit.shippingType,
                onSelected: cubit.selectShipping,
              ),
              const SizedBox(height: 16),
              Text(
                context.tr(LocaleKeys.condition),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              ChipsRow(
                options: [
                  ChipOption(
                      value: 'new',
                      label:
                          context.tr(LocaleKeys.conditionNew)),
                  ChipOption(
                      value: 'used',
                      label: context
                          .tr(LocaleKeys.conditionUsed)),
                ],
                selected: cubit.condition,
                onSelected: cubit.selectCondition,
              ),
            ],
          ),
        );

      // ── STEP 6 · المكان ──────────────────────────────────────────
      case 5:
        return FormCard(
          step: '6',
          title: context.tr(LocaleKeys.place),
          child: Column(
            children: [
              const CityDropdown(),
              const SizedBox(height: 12),
              const CenterDropdown(),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  /// Validation → (edit | free publish | payment step).
  Future<void> _onSubmitPressed(
    BuildContext context,
    AddNewAdCubit cubit,
  ) async {
    final error = cubit.validate();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(addNewAdValidationMessage(context, error))),
      );
      return;
    }
    if (cubit.isEditMode) {
      cubit.submitEdit();
      return;
    }
    // Same rule as the website: publish free only
    // while the package still has ads left; when the
    // package or the free ads are exhausted, force
    // the payment step (wallet / transfer).
    // Captured before the awaits so no BuildContext is used across them.
    final profileCubit = context.read<ProfileCubit>();
    setState(() => _checkingPackage = true);
    final coverage = await cubit.isPublishingCovered();
    if (!mounted) return;
    bool covered;
    if (coverage != null) {
      covered = coverage;
    } else {
      // Check failed (offline, etc.) → fall back to
      // the profile package instead of demanding a
      // payment the server may still not need.
      try {
        await profileCubit.getProfile();
      } catch (_) {}
      if (!mounted) return;
      covered = profileCubit.profileModel?.data?.user
              ?.subscriptionPackage !=
          null;
    }
    if (!mounted) return;
    setState(() => _checkingPackage = false);
    if (covered) {
      cubit.submit();
    } else {
      _openPaymentSheet();
    }
  }
}

/// Pinned bottom bar: optional Back ghost button + the gradient
/// Continue / Publish call-to-action.
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.showBack,
    required this.isLastStep,
    required this.isEditMode,
    required this.submitting,
    required this.isRtl,
    required this.onBack,
    required this.onNextOrSubmit,
  });

  final bool showBack;
  final bool isLastStep;
  final bool isEditMode;
  final bool submitting;
  final bool isRtl;
  final VoidCallback onBack;
  final VoidCallback onNextOrSubmit;

  @override
  Widget build(BuildContext context) {
    final ctaLabel = isLastStep
        ? (isEditMode
            ? context.tr(LocaleKeys.editAd)
            : context.tr(LocaleKeys.publishAd))
        : context.tr(LocaleKeys.next);
    final ctaIcon = isLastStep
        ? (isEditMode
            ? Icons.edit_rounded
            : Icons.rocket_launch_rounded)
        : (isRtl
            ? Icons.arrow_back_ios_new_rounded
            : Icons.arrow_forward_ios_rounded);
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withValues(alpha: 0.6),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showBack) ...[
            SizedBox(
              width: 116,
              child: OutlinedButton.icon(
                onPressed: submitting ? null : onBack,
                icon: Icon(
                  isRtl
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  size: 14,
                ),
                label: Text(context.tr(LocaleKeys.back)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.text,
                  side: BorderSide(
                    color: AppColors.border.withValues(alpha: 0.9),
                  ),
                  minimumSize: const Size(0, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: PremiumCtaButton(
              submitting: submitting,
              label: ctaLabel,
              icon: ctaIcon,
              onPressed: onNextOrSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
