import 'package:flutter/material.dart';
import 'notifier.dart';
import '../injector.dart';
import '../core/instrument.dart';
import '../core/dataTree/dataSpecForest.dart';
import '../core/dataTree/dataSpecNode.dart';
import '../middle/observerHandler.dart';
import '../backend/backendHandler.dart';
class UIAdapter extends ChangeNotifier {
  final Notifier _notifier = Notifier();
  bool buttonEnabled = true;
  late ObserverHandler o;
  initialiseNotifier() async{
    await _notifier.setupNotifications();
  } 
  initializeBackendAndObserverHandler() async{
    await getIt<BackendHandler>().init();
    o = ObserverHandler();
    _notifier.notify("loaded","...");
  }
  start() async{
    o.addObserver((Instrument(260105,"NIFTYBANK"),[
      DataSpecForest(5,[DataSpecNode<HeikenAshi>({},[DataSpecNode<EMA>({'period':21})])]);
    ]);
    buttonEnabled = false;
    notifyListeners();
  }
  sendError(String error){
    _notifier.notify(error);
  }
}
