import 'observers/observer.dart';
import '../ui/notifier.dart';
import '../injector.dart';
import '../backend/backendHandler.dart';
import 'observers/tempObserver.dart';
import '../core/instrument.dart';
class ObserverHandler{
    final Map<int,dynamic> observers = {};
    final notify = getIt<Notifier>().notify;
    late List<Instrument> options;
    bool isTempObserverRunning = false;
    ObserverHandler(){
        getIt<BackendHandler>().wsWrapper.stream.listen(listening);
        options = getIt<BackendHandler>().tokensHandler.getOptionTokens('BANKNIFTY',DateTime.utc(2021,9,23));
    }
    void listening(Map<String,dynamic> event){
      var ltps = event['ltps'];
      for(int x in ltps.keys){
          observers[x]!.ltpChanged(ltps[x],event['meta']['date'],event['meta']['isChanged']);
      }
    }
    addObserver(List<int> tokens) async{
        for(int x in tokens){
            observers[x] = Observer(x,notify,addOptionObserver);
            observers[x].startSync(getIt<BackendHandler>().getCandles);
            getIt<BackendHandler>().wsWrapper.subscribe(x);
        }
    }
    addOptionObserver(double ltp){
        for(var x in options){
            if(x.name.contains((ltp-(ltp%100)).toInt().toString())){
                print(x);
                addTempObserver(x);
                break;
            }
        }
    }
    addTempObserver(Instrument instrument){
        if(isTempObserverRunning){
            notify('moving average again tried adding',instrument.toString());
            return;
        }
        observers[instrument.token] = TempObserver(instrument,notify,removeTempObserver);
        getIt<BackendHandler>().wsWrapper.subscribe(instrument.token);
        isTempObserverRunning = true;
    }
    removeTempObserver(int token){
        getIt<BackendHandler>().wsWrapper.unsubscribe(token);
        observers[token] = null;
        isTempObserverRunning = false;
    }
}

 