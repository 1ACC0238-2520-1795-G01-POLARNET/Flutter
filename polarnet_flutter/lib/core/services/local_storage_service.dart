import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  late final SharedPreferences _prefs;
  late final FlutterSecureStorage _secureStorage;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();
  }

  // User Session
  Future<void> saveUserId(int userId) async {
    await _prefs.setInt(AppConstants.keyUserId, userId);
  }

  int? getUserId() {
    return _prefs.getInt(AppConstants.keyUserId);
  }

  Future<void> saveUserType(String userType) async {
    await _prefs.setString(AppConstants.keyUserType, userType);
  }

  String? getUserType() {
    return _prefs.getString(AppConstants.keyUserType);
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    await _prefs.setBool(AppConstants.keyIsLoggedIn, isLoggedIn);
  }

  bool isLoggedIn() {
    return _prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  // Secure Storage for tokens
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: AppConstants.keyAccessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: AppConstants.keyAccessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: AppConstants.keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConstants.keyRefreshToken);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
    await _secureStorage.deleteAll();
  }
}
