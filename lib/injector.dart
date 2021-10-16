import 'package:get_it/get_it.dart';
import 'ui/notifier.dart';

import 'backend/backendHandler.dart';
import 'ui/uiAdapter.dart';
final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton(BackendHandler());
  getIt.registerSingleton(UIAdapter());
}
