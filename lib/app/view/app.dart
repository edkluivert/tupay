import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tupay/core/constants/app_colors.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/core/logger/app_logger.dart';
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

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _authBloc.add(AppStarted());
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is FirstTimer) {
            AppLogger.w('Sending to app sign up');
            navigatorService.removeAllAndNavigateTo(Routes.appBottomNav);
          } else if (state is Unauthenticated) {
            AppLogger.d('Help me, Help me, Dem dey carry me go where i nor know');
            navigatorService.removeAllAndNavigateTo(Routes.login);
          } else {
            AppLogger.d('Developers are not aware of this problem');
            navigatorService.removeAllAndNavigateTo(Routes.login);
          }
        },
        child: AnnotatedRegion(
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
            home: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}
