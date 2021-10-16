import 'observers/observer.dart';
import '../injector.dart';
import '../core/indicator/indicatorSpecForest.dart';
import '../core/indicator/indicatorForest.dart';
import '../backend/backendHandler.dart';
import '../ui/UIAdapter.dart';
class ObserverHandler{
    Map<int,Observer> observers = {};
    addObserver(Instrument i,List<IndicatorSpecForest> specs){
        intervals = <int>[];
        for(var x in specs) intervals.add(x.interval);
        observers[i.token] = Observer(i,specs,getIt<BackendHandler>().getStream(i.token,intervals),(){
                getIt<BackendHandler>().sendSignals(signals);
                getIt<UIAdapter>().sendSignals(signals);
        });
    }
}

 