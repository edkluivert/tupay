import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'package:tupay/core/logger/app_logger.dart';

@lazySingleton
class NavigationService {
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  NavigatorState? get currentState => _navigationKey.currentState;

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    AppLogger.d('Pop route');
    return currentState!.pop();
  }

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    AppLogger.d('Push route');
    return currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> clearLastAndNavigateTo(String routeName, {Object? arguments}) {
    AppLogger.d('Pop and Push route');
    return currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<void> popUntil(String routeName) async {
    AppLogger.d('Pop until route: $routeName');

    currentState!.popUntil(
      ModalRoute.withName(routeName),
    );
  }

  void popUntilWithResult<T extends Object?>(
      String routeName, {
        T? result,
      }) {
    AppLogger.d('Pop until route with result: $routeName');

    currentState!.popUntilWithResult<T>(
      ModalRoute.withName(routeName),
      result,
    );
  }


  Future<dynamic> removeAllAndNavigateTo(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    AppLogger.d('Clear all routes');
    return currentState!.pushNamedAndRemoveUntil(
      routeName,
      predicate ?? (r) => false,
      arguments: arguments,
    );
  }
}
