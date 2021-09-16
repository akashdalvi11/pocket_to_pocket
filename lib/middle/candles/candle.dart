import 'dart:math';
import '../../core/rawCandle.dart';


class Candle{
    final DateTime dateTime;
    final double o,h,l,c,ema;
    Candle(this.dateTime,this.o,this.h,this.l,this.c,this.ema);
    static const double alpha = 2/11;
    Candle updatedCandle(double ltp){
        return Candle(this.dateTime,this.o,max(this.h,ltp),min(this.l,ltp),ltp,this.ema +alpha*(ltp-this.c));
    }
    Candle.justFormed(dateTime,ltp,previousEMA):
    this.dateTime = dateTime,
    this.o = ltp,
    this.h = ltp,
    this.l = ltp,
    this.c = ltp,
    this.ema = calculateMovingAverage(previousEMA,ltp);
    Candle.fromRawAndCurrentEMA(this.ema,RawCandle rawCandle):
    this.dateTime = rawCandle.dateTime,
        this.o = rawCandle.o,
        this.h = rawCandle.h,
        this.l = rawCandle.l,
        this.c = rawCandle.c;
    static List<Candle> createList(List<RawCandle> data){
        List<Candle> candles = [];
        double sma = 0;
        candles.add(fromRawAndPreviousEMA(data[0]));
        for(var i=1;i<data.length;i++){
            if(i<9) sma += data[i].c;
            if(i==9) candles.add(fromRawAndPreviousEMA(data[i],candles[i-1].ema,sma/10));
            else candles.add(fromRawAndPreviousEMA(data[i],candles[i-1].ema));
        }
        return candles;
    }
    static Candle fromRawAndPreviousEMA(RawCandle rawCandle,[double? previousEMA,double? sma]){
        var ema = 0.0;
        if(previousEMA != null) ema = sma ?? calculateMovingAverage(previousEMA,rawCandle.c);
        return Candle.fromRawAndCurrentEMA(ema,rawCandle);
    }

    static double calculateMovingAverage(previousEMA,currentClose){
        if(previousEMA == 0) return 0.0;
        return (previousEMA + alpha*(currentClose - previousEMA));
    }   
    String toString(){
        return "$dateTime-$o,$h,$c,$l,$ema";
    }
}
