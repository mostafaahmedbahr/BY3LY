import 'package:by3ly/core/utils/app_nav/new_app_nav.dart';
 import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../main_importants.dart';
import '../../../../layout/presentation/views/layout_view.dart';
import 'login_logo_image_widget.dart';
import '../../view_model/choose_location_cubit.dart';
import '../../view_model/choose_location_states.dart';
import 'choose_center.dart';
import 'choose_government.dart';
import 'choose_location_button.dart';

class ChooseLocationViewBody extends StatefulWidget {
  const ChooseLocationViewBody({super.key});

  @override
  State<ChooseLocationViewBody> createState() => _ChooseLocationViewBodyState();
}

class _ChooseLocationViewBodyState extends State<ChooseLocationViewBody> {
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChooseLocationCubit, ChooseLocationStates>(
      listener: (context, state) {
          if (state is AddLocationCitiesAndCentersSuccess
              && state.chooseLocationModel.status==false){
            CherryToast.success(
              title:   Text(state.chooseLocationModel.message!,
                  style: const TextStyle(color: Colors.black)),
            ).show(context);
            context.read<ProfileCubit>().getProfile();
          }

        else if(state is AddLocationCitiesAndCentersSuccess){
          CherryToast.success(
            title:   Text(state.chooseLocationModel.message!,
                style: const TextStyle(color: Colors.black)),
          ).show(context);
         NewAppNav.customNavigator(context: context, screen: const LayoutView(),
         finish: true);
          context.read<ProfileCubit>().getProfile();
        }
        else if(state is AddLocationCitiesAndCentersError){
          CherryToast.error(
            title:   Text( state.message,
                style: const TextStyle(color: Colors.black)),
          ).show(context);
        }
      },
      builder: (context, state) {
        var chooseLocationCubit = ChooseLocationCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  const LoginLogoImageWidget(),
                  const SizedBox(height: 10,),
                  Text(
                    context.tr(LocaleKeys.selectYourGeographicLocation),
                    style: AppStyles.textStyle16W500Black.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    context.tr(LocaleKeys.selectYourGovernorateFromTheFollowingList),
                    style: AppStyles.textStyle12W600Gary,
                  ),
                  const SizedBox(height: 40,),
                  const ChooseGovernment(),
                  if (chooseLocationCubit.countryIsSelect)
                    const ChooseCenter(),
                  const ChooseLocationButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
