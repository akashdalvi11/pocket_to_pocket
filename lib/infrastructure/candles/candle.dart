import 'dart:math';
import '../../domain/rawCandle.dart';


class Candle{
    final DateTime dateTime;
    final double o,h,l,c,EMA;
    Candle(this.dateTime,this.o,this.h,this.l,this.c,this.EMA);
    static const double alpha = 2/11;
    Candle updatedCandle(double ltp){
        return Candle(this.dateTime,this.o,max(this.h,ltp),min(this.l,ltp),ltp,this.EMA +alpha*(ltp-this.c));
    }
    Candle.justFormed(dateTime,ltp,previousEMA):
    this.dateTime = dateTime,
    this.o = ltp,
    this.h = ltp,
    this.l = ltp,
    this.c = ltp,
    this.EMA = calculateMovingAverage(previousEMA,ltp);
    Candle.fromRawAndCurrentEMA(this.EMA,RawCandle rawCandle):
    this.dateTime = rawCandle.dateTime,
        this.o = rawCandle.o,
        this.h = rawCandle.h,
        this.l = rawCandle.l,
        this.c = rawCandle.c;
    static List<Candle> createList(List<RawCandle> data){
        List<Candle> candles = [];
        double SMA = 0;
        candles.add(fromRawAndPreviousEMA(data[0]));
        for(var i=1;i<data.length;i++){
            if(i<9) SMA += data[i].c;
            if(i==9) candles.add(fromRawAndPreviousEMA(data[i],candles[i-1].EMA,SMA/10));
            else candles.add(fromRawAndPreviousEMA(data[i],candles[i-1].EMA));
        }
        return candles;
    }
    static Candle fromRawAndPreviousEMA(RawCandle rawCandle,[double? previousEMA,double? SMA]){
        var EMA = 0.0;
        if(previousEMA != null) EMA = SMA ?? calculateMovingAverage(previousEMA,rawCandle.c);
        return Candle.fromRawAndCurrentEMA(EMA,rawCandle);
    }

    static double calculateMovingAverage(previousEMA,currentClose){
        if(previousEMA == 0) return 0.0;
        return (previousEMA + alpha*(currentClose - previousEMA));
    }   
    String toString(){
        return "$dateTime-$o,$h,$c,$l,$EMA";
    }
}
