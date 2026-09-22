import 'dart:io';

import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'confirm_payment_states.dart';

class ConfirmPaymentCubit extends Cubit<ConfirmPaymentStates> {
  ConfirmPaymentCubit() : super(ConfirmPaymentInitState());

  static ConfirmPaymentCubit get(context) => BlocProvider.of(context);

  final ImagePicker picker = ImagePicker();
  File? image;

  Future<void> showPicker(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title:   Row(
                    children: [
                      Image.asset(AppImages.camera2,height: 40,),
                      const SizedBox(width: 10,),
                      Text(context.tr(LocaleKeys.uploadImageFromCamera)),
                    ],
                  ),
                  onTap: () {
                    pickImageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title:   Row(
                    children: [
                      Image.asset(AppImages.gallery,height: 40,),
                      const SizedBox(width: 10,),
                      Text(context.tr(LocaleKeys.uploadImageFromGallery)),
                    ],
                  ),
                  onTap: () {
                    pickImageFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> pickImageFromCamera() async {
    final XFile? xfileImage = await picker.pickImage(source: ImageSource.camera);
    if (xfileImage != null) {
      image = File(xfileImage.path);
      emit(PickImageFromCameraSuccessStates(image!));
    }
  }


  Future<void> pickImageFromGallery() async {
   final XFile? xfileImage = await picker.pickImage(source: ImageSource.gallery);
    if (xfileImage != null) {
        image = File(xfileImage.path);
        emit(PickImageFromGallerySuccessStates(image!));
    }
  }

}