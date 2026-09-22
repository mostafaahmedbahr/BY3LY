import 'dart:io';

abstract class ConfirmPaymentStates{}

class ConfirmPaymentInitState extends ConfirmPaymentStates{}

class PickImageFromCameraSuccessStates extends ConfirmPaymentStates{
  PickImageFromCameraSuccessStates(File imageFile);
}
class PickImageFromGallerySuccessStates extends ConfirmPaymentStates{
  PickImageFromGallerySuccessStates(File imageFile);
}