import 'dart:async';
import '../../core/dataForest/dataSpecForest.dart';
import '../../core/signal.dart';
import '../../core/data/interfaceData/ohlc.dart';
import 'observer.dart';
class HistoricalObserver{
    final DataSpecForest specs;
    final Future<List<dynamic>?> Function() getHistoricalData;
    final void Function(List<Signal>) signalCallback;
    final void Function(String s) errorCallback;
    HistoricalObserver(this.specs,this.getHistoricalData,this.signalCallback,this.errorCallback){
        getData();
    }
    startTheStream(List<dynamic> data) async{
        var s = StreamController<Map<String,dynamic>>();
        var signals = <Signal>[];
        Observer(specs,s.stream,(Signal signal){
                    signals.add(signal);
            });
        int splitIndex = 0;
        for(int i=0;i<data[0].length;i++){
            if(data[0][i] == DateTime.parse('2021-11-02 09:30:00')){
                splitIndex = i;
            }
        }
        var initialData = [data[0].sublist(0,splitIndex),data[1].sublist(0,splitIndex)];
        initialData[0].add(data[0][splitIndex]);
        initialData[1].add(OHLC.justFormed(data[1][splitIndex].o));
        s.add({'historical':true,'data':initialData});
        for(var i=splitIndex;i<data[0].length;i++){
            var ohlc = data[1][i];
            var dateTime = data[0][i];
            s.add(getMap(dateTime,ohlc.o));
            s.add(getMap(dateTime,ohlc.l));
            s.add(getMap(dateTime,ohlc.h));
            s.add(getMap(dateTime,ohlc.c));
        }
        await s.close();
        signalCallback(signals);
    }
    static getMap(DateTime dateTime,double ltp){
        return <String,dynamic>{'historical':false,'data':{'dateTime':dateTime,'ltp':ltp}};
    }
    getData() async{
        var l = await getHistoricalData();
        if(l == null){
            errorCallback('cannot get data');
        }else{
            startTheStream(l);
        }

    }

}