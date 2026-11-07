import 'package:by3ly/features/legalContent/data/models/legal_content_model.dart';

abstract class LegalContentStates {}

class LegalContentInitState extends LegalContentStates {}

class GetLegalContentLoadingState extends LegalContentStates {
  @override
  String toString() => 'GetLegalContentLoadingState';
}

class GetLegalContentSuccessState extends LegalContentStates {
  final LegalContentModel legalContentModel;
  GetLegalContentSuccessState(this.legalContentModel);

  @override
  String toString() =>
      'GetLegalContentSuccessState(title: ${legalContentModel.data?.title})';
}

class GetLegalContentErrorState extends LegalContentStates {
  final String error;
  GetLegalContentErrorState(this.error);

  @override
  String toString() => 'GetLegalContentErrorState(error: $error)';
}
