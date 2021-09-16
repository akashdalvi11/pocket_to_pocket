import 'package:get_it/get_it.dart';
import 'package:pocket_to_pocket/ui/notifier.dart';

import 'infrastructure/endPoint/endPoint.dart';
import 'infrastructure/endPoint/endPointHandler.dart';
final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton(EndPointHandler(EndPoint()));
  getIt.registerSingleton(Notifier());
}
