import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../view_model/choose_location_cubit.dart';
import '../../view_model/choose_location_states.dart';

/// Premium confirm button. Disabled and greyed-out until a city is picked.
class ChooseLocationButton extends StatelessWidget {
  const ChooseLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseLocationCubit, ChooseLocationStates>(
      builder: (context, state) {
        final cubit = ChooseLocationCubit.get(context);
        final hasCity = cubit.selectedCity.isNotEmpty;
        final submittable = hasCity && cubit.centerIsSelect;
        final loading = state is AddLocationCitiesAndCentersLoading;

        return SizedBox(
          height: 54,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: submittable
                  ? const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.mainColor,
                        AppColors.secondColor,
                      ],
                    )
                  : null,
              color: submittable ? null : const Color(0xffB6B6B6),
              boxShadow: submittable
                  ? [
                      BoxShadow(
                        color: AppColors.mainColor
                            .withValues(alpha: 0.45),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: submittable && !loading
                    ? () => cubit.addLocationCityAndCenter(
                          cityId: cubit.selectedCityId,
                          centerId: cubit.selectedCenterId,
                        )
                    : loading
                        ? null
                        : () => _showHint(context, cubit),
                child: loading
                    ? const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.tr(LocaleKeys.choose),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showHint(BuildContext context, ChooseLocationCubit cubit) {
    if (cubit.selectedCity.isEmpty) {
      CherryToast.info(
        title: Text(
          context.tr(LocaleKeys.selectGovernorate),
          style: const TextStyle(color: Colors.black),
        ),
      ).show(context);
      return;
    }
    CherryToast.info(
      title: Text(
        context.tr(LocaleKeys.chooseCenter),
        style: const TextStyle(color: Colors.black),
      ),
    ).show(context);
  }
}
