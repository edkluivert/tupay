import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tupay/app/view/app.dart';
import 'package:tupay/core/injections/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,);
  await configureDependencies();
  runApp(const App());
  // runApp(
  //   DevicePreview(
  //     builder: (context) {
  //       return const App();
  //     },
  //   ),
  // );

}



