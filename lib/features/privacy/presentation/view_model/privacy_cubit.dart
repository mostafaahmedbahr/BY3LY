import 'package:by3ly/features/privacy/presentation/view_model/privacy_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivacyCubit extends Cubit<PrivacyStates> {
  PrivacyCubit() : super(PrivacyInitState());

  static PrivacyCubit get(context) => BlocProvider.of(context);

  int wayIndex = 1 ;
  changeConnectionWay(index)
  {
    wayIndex = index;
    // print(wayIndex);
    emit(PrivacyChangeConnectionWayState());
  }


  List<String> numbers = [
    '01110690299',
    "01144398705",
    "01151816117",
  ];

  var phoneNumberCon = TextEditingController();

  changePhoneNumber(newNumber)
  {
    phoneNumberCon.text = newNumber;
    print(phoneNumberCon.text);
    emit(PrivacyChangePhoneNumberState());
  }

}