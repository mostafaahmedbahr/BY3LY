import 'package:easy_localization/easy_localization.dart';

import '../../../lang/locale_keys.dart';

class MyValidators {
  static String? displayNameValidator(String? displayName) {
    if (displayName == null || displayName.trim().isEmpty) {
      return LocaleKeys.nameValidate.tr(); // "Name is required"
    }

    final trimmed = displayName.trim();

    if (trimmed.length < 2) {
      return LocaleKeys.nameTooShort.tr(); // "Name must be at least 2 characters"
    }

    if (trimmed.length > 50) {
      return LocaleKeys.nameTooLong.tr(); // "Name cannot exceed 50 characters"
    }

    if (RegExp(r'[0-9]').hasMatch(trimmed)) {
      return LocaleKeys.nameNoNumbers.tr(); // "Name cannot contain numbers"
    }

    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(trimmed)) {
      return LocaleKeys.nameNoSpecialChars.tr(); // "Name cannot contain special characters"
    }

    return null;
  }


  static String? displayMessageValidator(String? message) {
    if (message == null || message.isEmpty) {
      return LocaleKeys.messageValidate.tr(); // "Message is required"
    }

    if (message.length < 10) {
      return LocaleKeys.messageTooShort.tr(); // "Message must be at least 10 characters"
    }

    if (message.length > 500) {
      return LocaleKeys.messageTooLong.tr(); // "Message cannot exceed 500 characters"
    }

    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.emailValidate.tr(); // "Email is required"
    }

    final emailRegex = RegExp(
        r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$'
    );

    if (!emailRegex.hasMatch(value)) {
      return LocaleKeys.emailValidate2.tr(); // "Please enter a valid email"
    }

    // Additional checks for common email issues
    if (value.contains(' ')) {
      return LocaleKeys.emailNoSpaces.tr(); // "Email cannot contain spaces"
    }

    if (value.startsWith('.') || value.endsWith('.')) {
      return LocaleKeys.emailInvalidDots.tr(); // "Email cannot start or end with a dot"
    }

    if ('@.'.allMatches(value).length > 1) {
      return LocaleKeys.emailMultipleAt.tr(); // "Email can only contain one @ symbol"
    }

    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.passwordValidate.tr(); // "Password is required"
    }

    // Detailed password requirements
    final requirements = <String>[];

    if (value.length < 8) {
      requirements.add(LocaleKeys.passwordMinLength.tr()); // "8 characters minimum"
    }

    if (value.length > 30) {
      requirements.add(LocaleKeys.passwordMaxLength.tr()); // "30 characters maximum"
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      requirements.add(LocaleKeys.passwordRequireUppercase.tr()); // "1 uppercase letter"
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      requirements.add(LocaleKeys.passwordRequireLowercase.tr()); // "1 lowercase letter"
    }

    if (!RegExp(r'\d').hasMatch(value)) {
      requirements.add(LocaleKeys.passwordRequireNumber.tr()); // "1 number"
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      requirements.add(LocaleKeys.passwordRequireSpecial.tr()); // "1 special character"
    }

    if (requirements.isNotEmpty) {
      return '${LocaleKeys.passwordRequirements.tr()}:\n${requirements.join('\n')}';
    }

    return null;
  }

  static String? urlValidator(String? value, {bool isRequired = false}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return LocaleKeys.urlRequired.tr(); // "URL is required"
    }

    if (value == null || value.isEmpty) {
      return null;
    }

    final urlRegex = RegExp(
        r'^(https?://)?' // http:// or https://
        r'([\w-]+\.)+[\w-]+' // Domain
        r'(:\d+)?' // Port
        r'(/[\w-./?%&=]*)?$' // Path and query
    );

    if (!urlRegex.hasMatch(value)) {
      return LocaleKeys.urlInvalid.tr(); // "Please enter a valid URL"
    }

    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      return LocaleKeys.urlMissingProtocol.tr(); // "URL must start with http:// or https://"
    }

    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.repeatPasswordRequired.tr(); // "Please repeat your password"
    }

    if (password == null || password.isEmpty) {
      return LocaleKeys.enterPasswordFirst.tr(); // "Please enter your password first"
    }

    if (value != password) {
      return LocaleKeys.passwordsDontMatch.tr(); // "Passwords don't match"
    }

    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.phoneRequired.tr();
    }

    final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');

    // تحقق من الرقم المصري فقط
    if (!RegExp(r'^01[0-9]{9}$').hasMatch(numericValue)) {
      return LocaleKeys.phoneEgyptInvalid.tr(); // "يجب أن يتكون الرقم المصري من 11 رقمًا ويبدأ بـ 01"
    }

    return null; // valid
  }

}