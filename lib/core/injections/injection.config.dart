// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:tupay/core/handlers/shared_preferences_wrapper.dart' as _i761;
import 'package:tupay/core/injections/register_module.dart' as _i574;
import 'package:tupay/core/navigation/navigation_service.dart' as _i675;
import 'package:tupay/features/app_bottom_nav/presentation/state_manager/app_bottom_nav_cubit.dart'
    as _i643;
import 'package:tupay/features/auth/presentation/state_manager/auth/auth_bloc.dart'
    as _i1035;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => registerModule.sharedPreferences,
    preResolve: true,
  );
  gh.lazySingleton<_i558.FlutterSecureStorage>(
    () => registerModule.flutterSecureStorage,
  );
  gh.lazySingleton<_i675.NavigationService>(() => _i675.NavigationService());
  gh.lazySingleton<_i643.AppBottomNavCubit>(() => _i643.AppBottomNavCubit());
  gh.lazySingleton<_i761.SharedPreferencesWrapper>(
    () =>
        registerModule.sharedPreferencesWrapper(gh<_i460.SharedPreferences>()),
  );
  gh.lazySingleton<_i1035.AuthBloc>(
    () => _i1035.AuthBloc(
      sharedPreferencesWrapper: gh<_i761.SharedPreferencesWrapper>(),
    ),
  );
  return getIt;
}

class _$RegisterModule extends _i574.RegisterModule {}
