import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../view_model/add_advertisements_cubit.dart';
import '../../view_model/add_advertisements_states.dart';

class Negotiable extends StatelessWidget {
  const Negotiable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddAdvertisementsCubit , AddAdvertisementsStates>(
        builder: (context,state){
      var addAdvertisementsCubit = AddAdvertisementsCubit.get(context);
      return
        /// قابل للتفاوض
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              activeColor: AppColors.mainColor,
              value: addAdvertisementsCubit.isChecked,
              onChanged: (value){
                addAdvertisementsCubit.toggleCheckbox(value);
              },
            ),
            Text(LocaleKeys.acceptable.tr()),
          ],
        );
    });
  }
}
