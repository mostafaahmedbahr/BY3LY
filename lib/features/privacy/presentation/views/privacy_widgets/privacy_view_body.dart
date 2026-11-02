import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:by3ly/features/privacy/data/models/settings_model.dart';
import 'package:by3ly/features/privacy/presentation/view_model/privacy_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/privacy_cubit.dart';

class PrivacyViewBody extends StatefulWidget {
  const PrivacyViewBody({super.key});

  @override
  State<PrivacyViewBody> createState() => _PrivacyViewBodyState();
}

class _PrivacyViewBodyState extends State<PrivacyViewBody> {
  @override
  void initState() {
    super.initState();
    // Reload on every open so the page always reflects the saved settings.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || GuestGuard.isGuest) return;
      PrivacyCubit.get(context).getSettings();
    });
  }

  String _methodLabel(BuildContext context, String value) {
    switch (value) {
      case 'chat':
        return context.tr(LocaleKeys.by3lyChat);
      case 'phone':
        return context.tr(LocaleKeys.phone2);
      case 'both':
        return context.tr(LocaleKeys.both);
    }
    for (final method
        in PrivacyCubit.get(context).settings?.contactMethods ?? const []) {
      if (method.value == value && (method.label?.trim().isNotEmpty ?? false)) {
        return method.label!;
      }
    }
    return value;
  }

  Widget _storeCard(BuildContext context, Settings? settings) {
    final name = settings?.storeName?.trim() ?? '';
    final address = settings?.storeAddress?.trim() ?? '';
    if (name.isEmpty && address.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.mainColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.storefront_outlined,
              color: AppColors.mainColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (name.isNotEmpty)
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                if (address.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrivacyCubit, PrivacyStates>(
      listener: (context, state) {
        if (state is UpdateSettingsSuccessState) {
          Toast.showSuccessToast(
            msg: (state.message?.trim().isNotEmpty ?? false)
                ? state.message!
                : context.tr(LocaleKeys.settingsUpdated),
            context: context,
          );
          Navigator.pop(context);
        } else if (state is UpdateSettingsErrorState) {
          Toast.showErrorToast(msg: state.error, context: context);
        } else if (state is GetSettingsErrorState &&
            PrivacyCubit.get(context).settings != null) {
          // Keep the already-loaded form visible when a background refresh
          // fails; the full error screen is only used before the first load.
          Toast.showErrorToast(msg: state.error, context: context);
        }
      },
      builder: (context, state) {
        final cubit = PrivacyCubit.get(context);

        if (state is GetSettingsLoadingState && cubit.settings == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GetSettingsErrorState && cubit.settings == null) {
          return CustomErrorWidget(
            error: state.error,
            onTap: cubit.getSettings,
          );
        }

        final methods = cubit.contactMethodValues;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              _storeCard(context, cubit.settings),
              Text(
                context.tr(LocaleKeys.connectionWy),
                style: AppStyles.textStyle16W600Black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    for (int i = 0; i < methods.length; i++)
                      _ConnectionMethodChip(
                        label: _methodLabel(context, methods[i]),
                        selected: cubit.wayIndex == i + 1,
                        onTap: () => cubit.changeConnectionWay(i + 1),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                context.tr(LocaleKeys.changePhoneNumber),
                style: AppStyles.textStyle16W600Black,
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: cubit.phoneNumberCon,
                keyboardType: TextInputType.phone,
                hintText: context.tr(LocaleKeys.enterNewPhoneNumber),
                prefixIcon: const Icon(
                  Icons.phone,
                  size: 20,
                  color: AppColors.mainColor,
                ),
              ),
              const SizedBox(height: 20),
              Material(
                color: AppColors.surface,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.border),
                ),
                child: SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  title: Text(
                    context.tr(LocaleKeys.notifyNewProducts),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  value: cubit.notifyNewProducts,
                  activeThumbColor: AppColors.mainColor,
                  onChanged: cubit.changeNotifyNewProducts,
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                btnText: cubit.isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.whiteColor,
                        ),
                      )
                    : Text(
                        context.tr(LocaleKeys.save),
                        style: AppStyles.textStyle16W600Black.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                onPressed: () {
                  if (!cubit.isSaving) cubit.saveSettings();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ConnectionMethodChip extends StatelessWidget {
  const _ConnectionMethodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selected ? AppColors.mainColor : AppColors.surface,
          border: Border.all(
            color: selected ? AppColors.mainColor : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.whiteColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
