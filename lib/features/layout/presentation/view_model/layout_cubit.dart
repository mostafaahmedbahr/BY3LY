import 'package:by3ly/features/chat/data/repos/chat_repository_impl.dart';
import 'package:by3ly/features/chat/presentation/view_model/chat_unread_cubit.dart';
import 'package:by3ly/features/chat/presentation/view_model/conversations_cubit.dart';
import 'package:by3ly/features/chat/presentation/views/conversations_view.dart';
import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/features/home/presentation/views/home_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../advertisements/presentation/views/advertisements_view.dart';
import '../../../profile/presentation/views/profile_view.dart';
import '../../../search/presentation/views/search_view.dart';
import 'layout_states.dart';


class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitState());

  static LayoutCubit get(context) => BlocProvider.of(context);

  static int pageIndex = 0;

  List screens = [
    const HomeView(),
    // Chat tab: ConversationsCubit is normally created by the conversations
    // route, so provide it here for the tab.
    BlocProvider(
      create: (context) => ConversationsCubit(
        getIt.get<ChatRepositoryImpl>(),
        getIt.get<ChatUnreadCubit>(),
      ),
      child: const ConversationsView(),
    ),
    const SearchView(),
    const AdvertisementsView(),
    const ProfileView(),

  ];



  changeBottomNav(index ,context) {
    pageIndex = index;
    emit(ChangeBottomNavState());
  }


}