import '../candles/candle.dart';
import 'observerSync.dart';
import '../../core/rawCandle.dart';

class Observer{
    final int token;
    final void Function(String,String) notify;
    ObserverSync? observerSync;
    bool synchronized = false;
    late bool isInMovingAverage;
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
            isInMovingAverage = checkMovingAverage(candles.last);
            print('history Moving average');
            print(isInMovingAverage);
        });
    }
    ltpChanged(double ltp,DateTime dateTime,bool isCandleChanged){
        if(synchronized){
            if(latestCandle.dateTime == dateTime){
                latestCandle = latestCandle.updatedCandle(ltp);
            }else{
                print(latestCandle);
                candles.add(latestCandle);
                latestCandle = Candle.justFormed(dateTime,ltp,candles.last.ema);
                checkEntry(ltp);
            }
        }else{
            observerSync!.ltpChanged(ltp,dateTime,isCandleChanged);
        }
    }
    checkMovingAverage(Candle c){
        var candleHeight = c.h - c.l;
        var upperLimit = c.l + (candleHeight/3);
        return upperLimit > c.ema;
    }
    checkEntry(double ltp){
        if(isInMovingAverage){
            if(!checkMovingAverage(candles.last)) isInMovingAverage = false;
        }else{
            if(checkMovingAverage(candles.last)){
                notify("moving","Average");
                addOptionObserver(ltp);
                isInMovingAverage = true;
            }
        }
    }
    
}
