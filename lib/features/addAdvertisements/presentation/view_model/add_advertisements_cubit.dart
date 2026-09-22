import 'dart:io';
import 'package:by3ly/features/addAdvertisements/data/models/add_advertisement_model.dart';
import 'package:by3ly/features/addAdvertisements/data/models/get_car_marka_model.dart';
import 'package:by3ly/features/addAdvertisements/data/models/get_car_types_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/get_car_models_model.dart';
import '../../data/repos/add_advertisements_repos.dart';
import 'add_advertisements_states.dart';

class AddAdvertisementsCubit extends Cubit<AddAdvertisementsStates> {
  AddAdvertisementsCubit(this.addAdvertisementsRepos) : super(AddAdvertisementsInitState());

  static AddAdvertisementsCubit get(context) => BlocProvider.of(context);

  final ImagePicker picker = ImagePicker();
  List<File> images = [];
  final int maxImages = 2;

  Future<void> pickImages(context) async {
    final List<XFile> selectedImages = await picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      if (images.length + selectedImages.length > maxImages) {
        images = (images + selectedImages.map((xfile) => File(xfile.path)).toList()).take(maxImages).toList();
        showMaxImagesWarning(context);
        emit(UploadImageSuccessState());
        debugPrint("---------- upload is done ------------");
      } else {
        images = selectedImages.map((xfile) => File(xfile.path)).toList();
        emit(UploadImageSuccessState());
        debugPrint("---------- upload is done ------------");
      }
    }

    // if (images.length >= maxImages) {
    //   showMaxImagesWarning(context);
    //   return;
    // }
  }

  void deleteImage(int index) {
    images.removeAt(index);
    emit(DeleteImageSuccessState());
  }

  void showMaxImagesWarning(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You can only upload up to 2 images.'),
      ),
    );
  }

  bool isChecked = false;
    toggleCheckbox(bool? value) {
    isChecked = value ?? false;
    emit(ToggleCheckboxSuccessState());
  }



  AddAdvertisementsRepos? addAdvertisementsRepos;
  AddAdvertisementModel? addAdvertisementModel;


  Future<void> addProductAdvertisement({
    required String nameAr,
    required String descAr,
    required String price,
    required int categoryId,
    required int subCategoryId,
    required int markaId,
    required int modelId,
    required int typeId,
    required double lat,
    required double long,
    required int communication,
    required int negotiable,
    required String phone,
    required dynamic images,
}) async {
    emit(AddProductAdvertisementsLoadingState());
    var result = await addAdvertisementsRepos!.addAdvertisement(
        nameAr: nameAr,
        descAr: descAr,
        price: price,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        markaId: markaId,
        modelId: modelId,
        typeId: typeId,
        lat: lat,
        long: long,
        communication: communication,
        negotiable: negotiable,
        phone: phone,
        images: images,
    );
    return result.fold((failure) {
      emit(AddProductAdvertisementsErrorState(failure.errMessage));
    }, (data) {
      if (data.status==true){
        addAdvertisementModel = data;
        emit(AddProductAdvertisementsSuccessState(data));
      }
      else{
        emit(AddProductAdvertisementsErrorState(data.message.toString()));
      }
    });
  }

 /// marka
  Marka? selectedCarMarka;
  int? selectedCarMarkaId;
  GetCarMarkaModel? getCarMarkaModel;
  List<Marka> allCarsMarkaList=[];
  Future<void> getAllCarsMarkaData() async {
    emit(GetCarsMarkaDataLoadingState());
    var result = await addAdvertisementsRepos!.getCarsMarka();
    return result.fold((failure) {
      emit(GetCarsMarkaDataErrorState(failure.errMessage));
    }, (data) {
      if(data.status==true){
        getCarMarkaModel = data;
       allCarsMarkaList =  getCarMarkaModel!.data!.marka!;
        emit(GetCarsMarkaDataSuccessState(data));
      }
      else{
        emit(GetCarsMarkaDataErrorState(data.message.toString()));
      }

    });
  }
  void selectCarMarkaMethod(Marka marka) {
    selectedCarMarka = marka;
    selectedCarMarkaId = marka.id;
    emit(SelectedCarMarkaSuccessState());
  }


  /// model
  Models? selectedCarModel;
  int? selectedCarModelId;
  GetCarModelsModel? getCarModelsModel;
  List<Models> allCarsModelsList=[];
  Future<void> getAllCarsModelsData() async {
    emit(GetCarsModelsDataLoadingState());
    var result = await addAdvertisementsRepos!.getCarsModels();
    return result.fold((failure) {
      emit(GetCarsModelsDataErrorState(failure.errMessage));
    }, (data) {
      if(data.status==true){
        getCarModelsModel = data;
        allCarsModelsList = allCarsModelsList + getCarModelsModel!.data!.models!;
        emit(GetCarsModelsDataSuccessState(data));
      }else
      {
        emit(GetCarsModelsDataErrorState(data.message.toString()));
      }

    });
  }
  void selectCarModelMethod(Models model) {
    selectedCarModel = model;
    selectedCarModelId = model.id;
    emit(SelectedCarModelSuccessState());
  }

  Typies? selectedCarType;
  int? selectedCarTypeId;
  GetCarTypesModel? getCarTypesModel;
  List<Typies> allCarsTypesList=[];
  Future<void> getAllCarsTypesData() async {
    emit(GetCarsTypesDataLoadingState());
    var result = await addAdvertisementsRepos!.getCarsTypes();
    return result.fold((failure) {
      emit(GetCarsTypesDataErrorState(failure.errMessage));
    }, (data) {
      if(data.status==true){
        getCarTypesModel = data;
        allCarsTypesList = allCarsTypesList + getCarTypesModel!.data!.typies!;
        emit(GetCarsTypesDataSuccessState(data));
      }
      else{
        emit(GetCarsTypesDataErrorState(data.message.toString()));
      }
    });
  }
  void selectCarTypesMethod(Typies type) {
    selectedCarType = type;
    selectedCarTypeId = type.id;
    emit(SelectedCarTypeSuccessState());
  }



  var advertiseNameCon = TextEditingController();
  var advertiseDesCon = TextEditingController();
  var advertisePriceCon = TextEditingController();
  var advertisePhoneCon = TextEditingController();


}
