import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:tupay/core/injections/injection.config.dart' as inject;

GetIt sl = GetIt.instance;

@InjectableInit(asExtension: false)
Future<void> configureDependencies() async => inject.init(sl);
