import 'dart:math';
import '../candles/candle.dart';
import 'observerSync.dart';
import '../../domain/rawCandle.dart';
import '../../domain/instrument.dart';

class Observer{
    final int token;
    final void Function(String,String) notify;
    ObserverSync? observerSync;
    bool synchronized = false;
    bool isInMovingAverage = false;
    late List<Candle> candles;
    late Candle latestCandle;
    final void Function(double) addOptionObserver;
    Observer(this.token,this.notify,this.addOptionObserver);
    startSync(Future<List<RawCandle>?> Function(int) getCandles){
        observerSync = ObserverSync(()=>getCandles(token),notify,(List<Candle> candles,Candle latestCandle){
            this.candles = candles;
            print(candles);
            this.latestCandle = latestCandle;
            synchronized = true;
            observerSync = null;
        });
    }
    ltpChanged(double ltp,DateTime dateTime,bool isCandleChanged){
        if(synchronized){
            if(latestCandle.dateTime == dateTime){
                latestCandle = latestCandle.updatedCandle(ltp);
            }else{
                checkEntry(ltp);
                print(latestCandle);
                latestCandle = Candle.justFormed(dateTime,ltp,candles.last.EMA);
            }
        }else{
            observerSync!.ltpChanged(ltp,dateTime,isCandleChanged);
        }
    }
    checkMovingAverage(){
        var candleHeight = latestCandle.h - latestCandle.l;
        var upperLimit = latestCandle.l + (candleHeight/3);
        return upperLimit > latestCandle.EMA;
    }
    checkEntry(double ltp){
        if(isInMovingAverage){
            if(!checkMovingAverage()) isInMovingAverage = false;
        }else{
            if(checkMovingAverage()){
                addOptionObserver(ltp);
                isInMovingAverage = true;
            }
        }
    }
    
}
