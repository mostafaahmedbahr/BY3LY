import 'package:by3ly/core/app_services/local_services/secure_storage_service.dart';

class CacheTokenManger {
  // Static variable to store the token
  static String? userToken;

  // Method to save the token
  static Future<void> saveUserToken(String token) async {
    userToken = token; // Store token in the static variable
    await SecureStorageService.instance
        .writeData(key: 'userToken', value: token); // Store securely
  }

  // Method to retrieve the token
  static Future<String?> getUserToken() async {
    // First check in the static variable
    if (userToken != null) {
      return userToken;
    }
    // If token is not in the static variable, get it from secure storage
    String? token =
        await SecureStorageService.instance.readData(key: 'userToken');
    userToken = token; // Store the token in the variable for future use
    return token;
  }

  // Method to clear the stored token
  static Future<void> clearUserToken() async {
    userToken = null; // Clear the token from the static variable
    await SecureStorageService.instance
        .deleteData(key: 'userToken'); // Remove it from secure storage
  }
}
