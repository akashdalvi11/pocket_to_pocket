import 'ohlc.dart';
import 'EMA.dart';
class OHLCEMA extends OHLC with EMA{
    static const alpha = 2/11;
   
    static List<OHLCEMA> createList(List<OHLC> candles){
        List<OHLCEMA> emaCandles = [];
        double sma = 0;
        candles.add(OHLCEMA.fromOHLCAndEMA(candles[0],0));
        for(var i=1;i<candles.length;i++){
            if(i<9) sma += candles[i].c;
            candles.add(OHLCEMA.fromOHLCAndEMA(candles[i],
            i==9?sma/10:
            calculateMovingAverage(emaCandles[i-1].ema,candles[i].c)));
        }
        return emaCandles;
    }
    static List<OHLCEMA> createList(List<OHLC> ohlcs){
        var l = <OHLCEMA>[];
        var values = <double>[];
        for(var x in ohlcs){
            l.add(OHLCEMA.fromOHLC(x));
            values.add(x.c);
        }
        var emaValues = EMAHelper.assignEMA(l,values,10);
    }
    static OHLCEMA fromOHLCAndPreviousEMA(OHLC ohlc,double previousEMA){
        var ema = calculateMovingAverage(previousEMA,ohlc.c);
        return OHLCEMA.fromOHLCAndEMA(ohlc,ema);
    }
    OHLCEMA(DateTime d,double o,double h,double l,double c,this.ema): super(d,o,h,l,c);
    OHLCEMA.fromOHLC(OHLC ohlc): super(ohlc.o,ohlc.h,ohlc.l,ohlc.c);
    OHLCEMA.justFormed(DateTime d,double ltp,double previousEMA)
        : this.ema = calculateMovingAverage(previousEMA,ltp)
        : super.justFormed(d,ltp);
    @override
    OHLCEMA updated(double ltp){
        var ohlc = super.updated(ltp);
        var ohlcEMA = OHLCEMA.fromOHLC(ohlc);
        ohlcEMA.setUpdatedEMA(super.ema,super.c,ltp);
        return ohlcEMA;
    }
}