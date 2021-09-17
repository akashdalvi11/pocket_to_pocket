import 'package:flutter/material.dart';
import '../middle/observerHandler.dart';
import '../injector.dart';
import '../backend/backendHandler.dart';
import 'notifier.dart';
class UIAdapter extends ChangeNotifier {
  var message = 'press it';
  String s = "";
  bool testButtonEnabled = true;
  late ObserverHandler o;
  initializeBackend() async{
    await getIt<BackendHandler>().init();
    getIt<Notifier>().notify("loaded","...");
  }
  test(){
    o = ObserverHandler();
    o.addObserver([260105]);
    testButtonEnabled = false;
    getIt<Notifier>().notify("started","...");
    notifyListeners();
    
  }
}
