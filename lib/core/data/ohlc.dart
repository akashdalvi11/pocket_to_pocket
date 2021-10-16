import 'timeFramedData.dart';
import 'dart:math';

class OHLC extends Data{
    final double o,h,l,c;
    OHLC(this.o,this.h,this.l,this.c);
    
    static OHLC justFormed(double ltp){
        return OHLC(ltp,ltp,ltp,ltp);
    }
    @override
    OHLC updated(double ltp){
        var low = min(this.l,ltp);
        var high = max(this.h,ltp);
        return OHLC(dateTime,o,high,low,ltp);
    }
    @override
    String toString(){
        return '$o,$h,$l,$c';
    }
}