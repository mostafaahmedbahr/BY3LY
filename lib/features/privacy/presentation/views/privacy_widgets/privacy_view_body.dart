import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/privacy_cubit.dart';
import '../../view_model/privacy_states.dart';
import 'privacy_loading.dart';
import 'privacy_method_chip.dart';
import 'privacy_store_card.dart';

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
      if (method.value == value &&
          (method.label?.trim().isNotEmpty ?? false)) {
        return method.label!;
      }
    }
    return value;
  }

  String _fallbackError() => LocaleKeys.settingsLoadFailed.tr();

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
          return const PrivacyLoading();
        }
        if (state is GetSettingsErrorState && cubit.settings == null) {
          return CustomErrorWidget(
            error: state.error.isNotEmpty ? state.error : _fallbackError(),
            onTap: cubit.getSettings,
          );
        }

        final methods = cubit.contactMethodValues;

        return SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            children: [
              PrivacyStoreCard(settings: cubit.settings),
              // Premium section label.
              _SectionLabel(text: context.tr(LocaleKeys.connectionWy)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (int i = 0; i < methods.length; i++)
                    PrivacyMethodChip(
                      label: _methodLabel(context, methods[i]),
                      selected: cubit.wayIndex == i + 1,
                      onTap: () => cubit.changeConnectionWay(i + 1),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              _SectionLabel(text: context.tr(LocaleKeys.changePhoneNumber)),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: cubit.phoneNumberCon,
                keyboardType: TextInputType.phone,
                hintText: context.tr(LocaleKeys.enterNewPhoneNumber),
                fillColor: AppColors.surface,
                radius: 14,
                prefixIcon: const Icon(
                  Icons.phone_rounded,
                  size: 20,
                  color: AppColors.mainColor,
                ),
              ),
              const SizedBox(height: 18),
              // Premium toggle card.
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mainColor.withValues(alpha: 0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SwitchListTile.adaptive(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  title: Text(
                    context.tr(LocaleKeys.notifyNewProducts),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ).copyWith(color: AppColors.text),
                  ),
                  value: cubit.notifyNewProducts,
                  activeThumbColor: AppColors.mainColor,
                  activeTrackColor: AppColors.mainColor.withValues(alpha: 0.45),
                  onChanged: cubit.changeNotifyNewProducts,
                ),
              ),
              const SizedBox(height: 36),
              // Premium pinned-looking gradient CTA.
              SizedBox(
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.mainColor, AppColors.secondColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainColor.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: cubit.isSaving ? null : cubit.saveSettings,
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: cubit.isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                context.tr(LocaleKeys.save),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Premium section label — bold dark title with an accent bar, same
/// pattern used across the app.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.yellowColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
