import 'package:by3ly/features/chooseLocation/data/repos/choose_location_repos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/choose_location_model.dart';
import '../../data/models/cities_centers_model.dart';
import 'choose_location_states.dart';

class ChooseLocationCubit extends Cubit<ChooseLocationStates> {
  ChooseLocationCubit(this.chooseLocationRepos)
      : super(ChooseLocationInitState());

  static ChooseLocationCubit get(BuildContext context) =>
      BlocProvider.of<ChooseLocationCubit>(context);

  final ChooseLocationRepos chooseLocationRepos;

  bool countryIsSelect = false;
  bool centerIsSelect = false;

  String selectedCity = '';
  int selectedCityId = 0;

  String selectedCenter = '';
  int selectedCenterId = 0;

  AllCitiesAndCentersModel? allCitiesAndCentersModel;
  ChooseLocationModel? chooseLocationModel;

  List<Cities> allCitiesList = [];
  List<Centers> allCentersList = [];

  void chooseCity(String cityName, int cityId) {
    selectedCity = cityName;
    selectedCityId = cityId;
    selectedCenter = '';
    selectedCenterId = 0;
    centerIsSelect = false;
    countryIsSelect = true;
    emit(ChooseLocationUpdateState());
  }

  void chooseCenter(String centerName, int centerId) {
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
    centerIsSelect = false;
    allCentersList = [];
    emit(ChooseLocationUpdateState());
  }

  void resetCenterSelection() {
    selectedCenter = '';
    selectedCenterId = 0;
    centerIsSelect = false;
    emit(ResetCenterState());
  }

  Future<void> getAllCitiesAndCenters() async {
    allCitiesList = [];
    allCentersList = [];
    emit(GetAllCitiesAndCentersLoading());
    final result = await chooseLocationRepos.getAllCitiesAndCentersData();
    return result.fold(
      (failure) => emit(GetAllCitiesAndCentersError(failure.errMessage)),
      (data) {
        if (data.status == true) {
          allCitiesAndCentersModel = data;
          allCitiesList = data.data?.cities ?? [];
          if (allCitiesList.isNotEmpty) {
            allCentersList = allCitiesList.first.centers ?? [];
          }
          emit(GetAllCitiesAndCentersSuccess(data));
        } else {
          emit(GetAllCitiesAndCentersError(
            data.message ?? 'حدث خطأ غير متوقع',
          ));
        }
      },
    );
  }

  void filterCentersByCity(int cityId) {
    final city = allCitiesList.firstWhere(
      (c) => c.id == cityId,
      orElse: () => Cities(),
    );
    allCentersList = city.centers ?? [];
    emit(CentersFilteredSuccessState());
  }

  Future<void> addLocationCityAndCenter({
    required int cityId,
    required int centerId,
  }) async {
    emit(AddLocationCitiesAndCentersLoading());
    final result = await chooseLocationRepos.chooseLocationCityAndCenter(
      cityId: cityId,
      centerId: centerId,
    );
    return result.fold(
      (failure) => emit(AddLocationCitiesAndCentersError(failure.errMessage)),
      (data) {
        if (data.status == true) {
          chooseLocationModel = data;
          emit(AddLocationCitiesAndCentersSuccess(data));
        } else {
          emit(AddLocationCitiesAndCentersError(
            data.message ?? 'حدث خطأ غير متوقع',
          ));
        }
      },
    );
  }
}
