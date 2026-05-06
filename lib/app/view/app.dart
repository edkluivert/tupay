import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_application/secure_application.dart';
import 'package:tupay/app/view/secure_app_gate.dart';
import 'package:tupay/core/constants/app_colors.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/core/navigation/navigation_service.dart';
import 'package:tupay/core/navigation/route_generator.dart';
import 'package:tupay/core/navigation/route_paths.dart';
import 'package:tupay/core/theme/tupay_theme.dart';
import 'package:tupay/features/auth/presentation/state_manager/auth/auth_bloc.dart';
import 'package:tupay/features/auth/presentation/state_manager/auth/auth_event.dart';
import 'package:tupay/features/auth/presentation/state_manager/auth/auth_state.dart';
import 'package:tupay/features/onboarding/presentation/pages/splash_screen.dart';


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthBloc _authBloc;

  final navigatorService = sl<NavigationService>();

  Timer? _navigationTimer;
  bool _hasNavigated = false;

  static const _splashDelay = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _authBloc.add(AppStarted());
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _authBloc.close();
    super.dispose();
  }

  void _scheduleInitialNavigation(String route) {
    if (_hasNavigated) return;

    _navigationTimer?.cancel();

    _navigationTimer = Timer(_splashDelay, () {
      if (!mounted || _hasNavigated) return;

      final navigatorState = navigatorService.navigationKey.currentState;
      if (navigatorState == null) return;

      _hasNavigated = true;
      navigatorService.removeAllAndNavigateTo(route);
    });
  }

  void _navigateImmediately(String route) {
    _navigationTimer?.cancel();

    final navigatorState = navigatorService.navigationKey.currentState;
    if (navigatorState == null) return;

    _hasNavigated = true;
    navigatorService.removeAllAndNavigateTo(route);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is FirstTimer) {
            _scheduleInitialNavigation(Routes.signup);
            return;
          }

          if (state is Unauthenticated) {
            if (_hasNavigated) {
              _navigateImmediately(Routes.login);
            } else {
              _scheduleInitialNavigation(Routes.login);
            }
          }
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: AppColors.secondaryColor,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: MaterialApp(
            title: 'TuPay',
            theme: TupayTheme.createLightThemeData(),
            onGenerateRoute: generateRoute,
            onUnknownRoute: generateRoute,
            navigatorKey: navigatorService.navigationKey,
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'tupay_app',
            home: const SplashScreen(),
            builder: (context, child) {
              return SecureApplication(
                nativeRemoveDelay: 800,
                child: SecureAppGate(
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}