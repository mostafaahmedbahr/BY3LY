abstract class AddNewAdStates {}

class AddNewAdInit extends AddNewAdStates {
  @override
  String toString() => 'AddNewAdInit';
}

class AddNewAdImagesChanged extends AddNewAdStates {
  @override
  String toString() => 'AddNewAdImagesChanged';
}

class AddNewAdSelectionChanged extends AddNewAdStates {
  @override
  String toString() => 'AddNewAdSelectionChanged';
}

class AddNewAdLoading extends AddNewAdStates {
  @override
  String toString() => 'AddNewAdLoading';
}

class AddNewAdSuccess extends AddNewAdStates {
  final String? message;
  AddNewAdSuccess(this.message);

  @override
  String toString() => 'AddNewAdSuccess(message: $message)';
}

class AddNewAdError extends AddNewAdStates {
  final String message;
  AddNewAdError(this.message);

  @override
  String toString() => 'AddNewAdError(message: $message)';
}

/// The server rejected the publish because payment fields were missing
/// (package/free ads exhausted) → the payment step must be reopened.
class AddNewAdPaymentRequired extends AddNewAdStates {
  final String message;
  AddNewAdPaymentRequired(this.message);

  @override
  String toString() => 'AddNewAdPaymentRequired(message: $message)';
}
