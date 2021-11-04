import '../injector.dart';
import '../core/dataForest/dataSpecForest.dart';
import '../core/instrument.dart';
import '../core/signal.dart';
import '../core/observerMeta.dart';
import '../backend/backendAdapter.dart';
import '../ui/uiAdapter.dart';
import 'observer/observer.dart';
import 'observer/historicalObserver.dart';
class ObserverHandler{
    Map<ObserverMeta,Observer> observers = {};
    addObserver(ObserverMeta m,DataSpecForest specs){
        observers[m] = 
            Observer(specs,getIt<BackendAdapter>().getStream(m.instrument.token,m.interval),(Signal s){
                print(s);
                getIt<BackendAdapter>().sendSignals(m,s);
                getIt<UIAdapter>().sendSignals(m,s);
            });
    }
    removeObserver(ObserverMeta m) async{
        await getIt<BackendAdapter>().disposeStream(m.instrument.token,m.interval);
        observers.remove(m);
    }
    addHistoricalObserver(ObserverMeta m,DataSpecForest specs){
        HistoricalObserver(specs,()=>getIt<BackendAdapter>().getHistoricalData(m.instrument.token,m.interval),(List<Signal> signals){
            for(var x in signals) print(x);
        },(String s){
            print(s);
        });
    }
}

 