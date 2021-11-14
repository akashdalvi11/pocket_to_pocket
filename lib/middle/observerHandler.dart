import '../injector.dart';
import '../core/dataForest/dataSpecForest.dart';
import '../core/instrument.dart';
import '../core/signal.dart';
import '../core/observerMeta/observerMeta.dart';
import '../core/observerMeta/historicalObserverMeta.dart';
import '../core/observers/observer.dart';
import '../core/observers/historicalObserver.dart';
import '../backend/backendAdapter.dart';
import '../ui/uiAdapter.dart';
class ObserverHandler{
    Map<ObserverMeta,Observer> _observers = {};
    Map<ObserverMeta,List<Signal>> signals = {};
    addObserver(ObserverMeta m,DataSpecForest specs){
        signals[m] = [];
        _observers[m] = Observer(specs,
            getIt<BackendAdapter>().getStream(m.instrument.token,m.interval),
            (Signal s){
                signals[m]!.add(s);
                getIt<BackendAdapter>().sendSignals(m,s);
                getIt<UIAdapter>().notifyListeners();
            }
        );
    }
    removeObserver(ObserverMeta m) async{
        await getIt<BackendAdapter>().disposeStream(m.instrument.token,m.interval);
        _observers.remove(m);
        signals.remove(m);
    }
    addHistoricalObserver(HistoricalObserverMeta m,DataSpecForest specs){
        signals[m] = [];
        HistoricalObserver(
            specs,
            m.from,
            ()=>getIt<BackendAdapter>().getHistoricalData(m.instrument.token,m.interval),
            (List<Signal> signalsRecieved){
                signals[m] = signalsRecieved;
                getIt<UIAdapter>().notifyListeners();
            },
            (String s){
                print(s);
            }
        );
    }
}

 