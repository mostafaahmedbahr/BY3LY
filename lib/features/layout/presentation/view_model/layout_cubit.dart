import 'package:by3ly/features/home/presentation/views/home_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../advertisements/presentation/views/advertisements_view.dart';
import '../../../notifications/presentation/views/notifications_view.dart';
import '../../../profile/presentation/views/profile_view.dart';
import '../../../search/presentation/views/search_view.dart';
import 'layout_states.dart';


class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitState());

  static LayoutCubit get(context) => BlocProvider.of(context);

  static int pageIndex = 0;

  List screens = [
    const HomeView(),
    const NotificationsView(),
    const SearchView(),
    const AdvertisementsView(),
    const ProfileView(),

  ];



  changeBottomNav(index ,context) {
    pageIndex = index;
    emit(ChangeBottomNavState());
  }


}