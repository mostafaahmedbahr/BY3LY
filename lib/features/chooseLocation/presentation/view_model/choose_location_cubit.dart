import 'package:by3ly/features/chooseLocation/data/repos/choose_location_repos.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/choose_location_model.dart';
import '../../data/models/cities_centers_model.dart';
import 'choose_location_states.dart';

class ChooseLocationCubit extends Cubit<ChooseLocationStates> {
  ChooseLocationCubit(this.chooseLocationRepos) : super(ChooseLocationInitState());

  static ChooseLocationCubit get(context) => BlocProvider.of(context);


  bool countryIsSelect = false;

  String selectedCity = '';
  int selectedCityId =  0;

  String selectedCenter = '';
  int selectedCenterId = 0;

  void chooseCity(String cityName , int cityId) {
    selectedCity = cityName;
    selectedCityId = cityId;
    selectedCenter = ''; // Reset center selection
    selectedCenterId = 0; // Reset center selection
    countryIsSelect = true;
    emit(ChooseLocationUpdateState());
  }

  void chooseCenter(String centerName , int centerId) {
    selectedCenter = centerName;
    selectedCenterId = centerId;
    centerIsSelect = true;
    emit(ChooseLocationUpdateState());
  }

  void resetSelection() {
    selectedCity = '';
    selectedCityId = 0;
    selectedCenter = '';
    selectedCenterId = 0;
    countryIsSelect = false;
    emit(ChooseLocationUpdateState());
  }



  ChooseLocationRepos? chooseLocationRepos;
  AllCitiesAndCentersModel? allCitiesAndCentersModel;

  List<Cities> allCitiesList=[];
  List<Centers> allCentersList=[];
  Future<void> getAllCitiesAndCenters() async {
    allCitiesList = [];
    allCentersList = [];
    emit(GetAllCitiesAndCentersLoading());
    var result = await chooseLocationRepos!.getAllCitiesAndCentersData();
    return result.fold((failure) {
      emit(GetAllCitiesAndCentersError(failure.errMessage));
    }, (data) {
      if(data.status==true){
        allCitiesAndCentersModel = data;
        allCitiesList = data.data!.cities ?? [];
        if (allCitiesList.isNotEmpty) {
          allCentersList = allCitiesList.first.centers ?? [];
        }
        emit(GetAllCitiesAndCentersSuccess(data));
      }
      else{
        emit(GetAllCitiesAndCentersError(data.message!));
      }
    });
  }

  void filterCentersByCity(int cityId) {
    final selectedCity = allCitiesList.firstWhere((city) => city.id == cityId, orElse: () => Cities());
    allCentersList = selectedCity.centers ?? [];
    emit(CentersFilteredSuccessState());
  }


  ChooseLocationModel? chooseLocationModel;
  Future<void> addLocationCityAndCenter({
    required String cityId, required String centerId
}) async {
    emit(AddLocationCitiesAndCentersLoading());
    var result = await chooseLocationRepos!.chooseLocationCityAndCenter(
        cityId: cityId, centerId: centerId);
    return result.fold((failure) {
      emit(AddLocationCitiesAndCentersError(failure.errMessage));
    }, (data) {
      if(data.status==true){
        chooseLocationModel = data;
        emit(AddLocationCitiesAndCentersSuccess(data));
      }
      else{
        emit(AddLocationCitiesAndCentersError(data.message!));
      }
    });
  }


  bool centerIsSelect = false;


  void resetCenterSelection() {
    selectedCenter = '';
    selectedCenterId = 0;
    centerIsSelect = false;
    emit(ResetCenterState());
  }

}