import 'package:get_it/get_it.dart';
import 'ui/uiAdapter.dart';
import 'middle/observerHandler.dart';
import 'backend/backendAdapter.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton(UIAdapter());
  getIt.registerSingleton(ObserverHandler());
  getIt.registerSingleton(BackendAdapter());
}
