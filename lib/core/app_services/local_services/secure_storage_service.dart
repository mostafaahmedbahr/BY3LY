import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Create a private constructor for singleton
  SecureStorageService._();

  // The singleton instance
  static final SecureStorageService instance = SecureStorageService._();

  // Create an instance of FlutterSecureStorage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Method to write data securely
  Future<void> writeData({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  // Method to read data securely
  Future<String?> readData({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  // Method to delete data securely
  Future<void> deleteData({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  // Method to delete all data
  Future<void> deleteAllData() async {
    await _secureStorage.deleteAll();
  }
}