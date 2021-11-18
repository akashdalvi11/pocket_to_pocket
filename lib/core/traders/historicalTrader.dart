import 'dart:async';
import '../dataForest/dataSpecForest.dart';
import '../data/interfaceData/ohlc.dart';
import '../trade.dart';
import '../instrument.dart';
import 'trader.dart';
class HistoricalTrader{
    final Instrument instrument;
    final DataSpecForest specs;
    final DateTime start;
    final Future<List<dynamic>?> Function() getHistoricalData;
    final void Function(List<Trade>) tradesCallback;
    final void Function(String s) errorCallback;
    HistoricalTrader(this.instrument,this.specs,this.start,this.getHistoricalData,this.tradesCallback,this.errorCallback){
        getData();
    }
    startTheStream(List<dynamic> data) async{
        var s = StreamController<Map<String,dynamic>>();
        var trades = <Trade>[]; 
        var trader = Trader(specs,s.stream,trades,(entry){
            trades.add(Trade(instrument,entry));
        },(exit){
            trades.last.addExit(exit);
        });
        int splitIndex = 0;
        for(int i=0;i<data[0].length;i++){
            if(data[0][i] == start){
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
        tradesCallback(trades);
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