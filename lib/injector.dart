import 'package:get_it/get_it.dart';
import 'ui/uiAdapter.dart';
import 'middle/traderHandler.dart';
import 'middle/globals.dart';
import 'backend/backendAdapter.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton(TraderHandler());
  getIt.registerSingleton(Globals());
  getIt.registerSingleton(UIAdapter());
  getIt.registerSingleton(BackendAdapter());
}
