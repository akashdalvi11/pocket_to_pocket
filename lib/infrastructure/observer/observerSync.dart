
import '../../domain/rawCandle.dart';
import '../candles/candle.dart';
import 'dart:math';
class ObserverSync{
    final Future<List<RawCandle>?> Function() getCandles;
    final void Function(String,String) notify;
    final void Function(List<Candle>,Candle) setCandles;
    late RawCandle latestCandle;
    bool fetchingFailed = false;
    bool latestCandleNull = true;
    var isStarted = false;
    ObserverSync(this.getCandles,this.notify,this.setCandles);
    ltpChanged(double ltp,DateTime dateTime,bool isCandleChanged){
        if(!isStarted) if(isCandleChanged) isStarted = true;
        if(isStarted){
            if(latestCandleNull){
                latestCandle = RawCandle(dateTime,ltp,ltp,ltp,ltp);
                latestCandleNull = false;
                loadCandles();
            }else if(latestCandle.dateTime == dateTime){
                var high = max(latestCandle.h,ltp);
                var low = min(latestCandle.l,ltp);
                latestCandle = RawCandle(dateTime,latestCandle.o,high,low,ltp);
            }else{
                if(fetchingFailed){
                    loadCandles();
                    fetchingFailed = false;
                }
                latestCandle = RawCandle(dateTime,ltp,ltp,ltp,ltp);
            }
        }
    }
    void loadCandles() async{
        var rawCandles = (await getCandles());
        if(rawCandles==null){
            notify("failure","fetchingFailed");
            fetchingFailed = true;
        } else{
            var candles = Candle.createList(rawCandles);
            setCandles(candles,Candle.fromRawAndPreviousEMA(latestCandle,candles.last.EMA));
        }
    }
}