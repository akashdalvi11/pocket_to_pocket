import '../core/data/interfaceData/ohlc.dart';
import 'dart:async';
class IntervalStream{
    final int interval;
    final Future<List<dynamic>?> Function() getData;
    final streamController = StreamController<Map<String,dynamic>>();
    OHLC? ohlc;
    DateTime? latestEdged;
    bool isStarted = false;
    bool isLoaded = false;
    DateTime edgedDateTime(DateTime datetime){
        return datetime.subtract(Duration(
            minutes:datetime.minute % interval,
            milliseconds: datetime.millisecond,
            microseconds: datetime.microsecond,
            seconds: datetime.second));
    }
    IntervalStream(this.interval,this.getData);
    add(Map<String,dynamic> map){
        DateTime currentEdged = edgedDateTime(map['data']['dateTime']);
        if(!isLoaded){
            print(map);
            load(currentEdged,map);
        }else{
            map['data']['dateTime'] = currentEdged;
            streamController.add(
                {'historical':false,
                'data':map['data'],
                });
        }
    }
    checkIfStarted(DateTime currentEdged){
        if(latestEdged == null) latestEdged = currentEdged;
        else if(latestEdged != currentEdged){
            latestEdged = currentEdged;
            isStarted = true;
        }
    }
    load(DateTime currentEdged,map){
        if(!isStarted) checkIfStarted(currentEdged);
        if(isStarted){
            if(ohlc == null){
                ohlc = OHLC.justFormed(map['data']['ltp']);
                loadData();
            }else if(latestEdged == currentEdged){
                ohlc =  ohlc!.updated(map['data']['ltp']);
            }else{
                loadData();
                latestEdged = currentEdged;
                ohlc = OHLC.justFormed(map['data']['ltp']);
            }
        }
    }
    loadData() async{
        var data = (await getData());
        if(data == null){
            streamController.addError('cannot fetch data');
        }else{
            if(data[0].last == latestEdged){
                data[0].removeLast();
                data[1].removeLast();
            }
            data[0].add(latestEdged!);
            data[1].add(ohlc);
            streamController.add({'historical':true,'data':data});
            isLoaded = true;
        }
    }
    Future<void> close() async{
        await streamController.close();
    }
    String toString(){
        return "intervalStream $interval";
    }
}