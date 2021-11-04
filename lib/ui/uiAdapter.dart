import 'package:flutter/material.dart';
import '../injector.dart';
import '../core/instrument.dart';
import '../core/signal.dart';
import '../core/analyserInference.dart';
import '../core/dataForest/dataSpecForest.dart';
import '../core/dataForest/interfaceSpecNode.dart';
import '../core/dataForest/dataSpecNode.dart';
import '../core/data/interfaceData/ohlc.dart';
import '../core/data/heikenAshi.dart';
import '../core/data/ema.dart';
import '../core/data/sma.dart';
import '../core/data/stochastic.dart';
import '../core/observerMeta.dart';
import '../middle/observerHandler.dart';
import '../backend/backendAdapter.dart';
import 'notifier.dart';

class UIAdapter extends ChangeNotifier {
  final Notifier _notifier = Notifier();
  bool buttonEnabled = true;
  final List<Signal> signals = [];
  initialiseNotifier() async {
    await _notifier.setupNotifications();
  }

  initializeBackend() async {
    await getIt<BackendAdapter>().init();
    _notifier.notify("loaded", "...");
  }
  test(){
    var o = ObserverMeta(Instrument(24334,"wer"),5);
    var s = Signal(DateTime.now(),AnalyserInference.up,24.5);
    getIt<BackendAdapter>().sendSignals(o,s);
    sendSignals(o,s);
  }
  start() {
    var i = Instrument(260105, "NIFTYBANK");
    getIt<ObserverHandler>().addObserver(ObserverMeta(i,5),
      DataSpecForest([
        InterfaceSpecNode<OHLC>([
          DataSpecNode<HeikenAshi>({}, [
            DataSpecNode<EMA>({'period':9},[]),
            DataSpecNode<Stochastic>({'period':9},[
              DataSpecNode<SMA>({'period':3},[
                DataSpecNode<SMA>({'period':3},[])
              ])
            ])
          ])
        ])
      ])
    );
    buttonEnabled = false;
    notifyListeners();
  }
  sendSignals(ObserverMeta o, Signal signal) {
    signals.add(signal);
    _notifier.notify('signal',signal.toString());
    notifyListeners();
  }

  sendError(String error) {
    _notifier.notify("error", error);
  }
}
