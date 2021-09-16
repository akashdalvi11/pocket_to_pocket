import 'observer.dart';
import '../../ui/notifier.dart';
import '../../injector.dart';
import '../endPoint/endPointHandler.dart';
import 'tempObserver.dart';
import '../../domain/instrument.dart';
class ObserverHandler{
    final Map<int,dynamic> observers = {};
    final notify = getIt<Notifier>().notify;
    late List<Instrument> options;
    bool isTempObserverRunning = false;
    ObserverHandler(){
        getIt<EndPointHandler>().wsWrapper.stream.listen(listening);
        options = getIt<EndPointHandler>().tokensHandler.getOptionTokens('BANKNIFTY',DateTime.now());
    
    }
    void listening(Map<String,dynamic> event){
      var ltps = event['ltps'];
      print(event);
      for(int x in ltps.keys){
          if(event['meta']['isChanged'])
          print(event['meta']['isChanged']);
          observers[x]!.ltpChanged(ltps[x],event['meta']['date'],event['meta']['isChanged']);
      }
    }
    addObserver(List<int> tokens) async{
        for(int x in tokens){
            observers[x] = Observer(x,notify,addOptionObserver);
            observers[x].startSync(getIt<EndPointHandler>().getCandles);
            getIt<EndPointHandler>().wsWrapper.subscribe(x);
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
            notify('movingAverageAgain','again');
            return;
        }
        observers[instrument.token] = TempObserver(instrument,notify,removeTempObserver);
        getIt<EndPointHandler>().wsWrapper.subscribe(instrument.token);
        isTempObserverRunning = true;
    }
    removeTempObserver(int token){
        getIt<EndPointHandler>().wsWrapper.unsubscribe(token);
        observers[token] = null;
        isTempObserverRunning = false;
    }
}

 