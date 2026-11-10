import '../../data/models/delete_account_model.dart';

abstract class DeleteAccountStates {}

class DeleteAccountInitState extends DeleteAccountStates {}

class DeleteAccountLoading extends DeleteAccountStates {}

class DeleteAccountSuccess extends DeleteAccountStates {
  final DeleteAccountModel deleteAccountModel;
  DeleteAccountSuccess(this.deleteAccountModel);
}

class DeleteAccountError extends DeleteAccountStates {
  /// Null when the server rejected the deletion without a message —
  /// the view substitutes a localized fallback.
  final String? message;
  DeleteAccountError(this.message);
}
