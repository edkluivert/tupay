import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tupay/core/handlers/shared_preferences_wrapper.dart';
import 'package:tupay/core/services/current_user_service.dart';

@module
abstract class RegisterModule {
  // LocalAuthentication get localAuthentication => LocalAuthentication();

  @lazySingleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage();

  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  SharedPreferencesWrapper sharedPreferencesWrapper(
      SharedPreferences sharedPreferences,
      ) {
    return SharedPreferencesWrapper(sharedPreferences);
  }

  @lazySingleton
  CurrentUserService get currentUserService => CurrentUserService();
}