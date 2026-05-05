// ignore_for_file: always_use_package_imports



import 'package:flutter/material.dart';
import 'package:tupay/core/navigation/route_paths.dart';
import 'package:tupay/features/app_bottom_nav/presentation/pages/app_bottom_nav_screen.dart';
import 'package:tupay/features/auth/presentation/pages/forgot_password/forgot_password_screen.dart';
import 'package:tupay/features/auth/presentation/pages/login/login_screen.dart';
import 'package:tupay/features/auth/presentation/pages/reset_password/reset_password_screen.dart';
import 'package:tupay/features/auth/presentation/pages/sign_up/sign_up_screen.dart';
import 'package:tupay/features/profile/presentation/pages/linked_accounts_screen.dart';
import 'package:tupay/features/profile/presentation/state_manager/profile_state.dart';
import 'package:tupay/features/wallet/presentation/pages/wallet_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.signup:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignupScreen(),
      );

    case Routes.login:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginScreen(),
      );

    case Routes.forgotPassword:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ForgotPasswordScreen(),
      );

    case Routes.resetPassword:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ResetPasswordScreen(),
      );

    case Routes.appBottomNav:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: AppBottomNavScreen(),
      );
    case Routes.wallet:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: WalletScreen(),
      );
    case Routes.linkedAccounts:
      final state = settings.arguments! as ProfileSuccess;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LinkedAccountsScreen(state: state),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

Route<void> _getPageRoute({
  String? routeName,
  required Widget viewToShow,
}) {
  return PageRouteBuilder<void>(
    settings: RouteSettings(name: routeName),
    transitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (context, animation, secondaryAnimation) => viewToShow,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      final slideAnimation = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(curvedAnimation);

      final fadeAnimation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(curvedAnimation);

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      );
    },
  );
}
