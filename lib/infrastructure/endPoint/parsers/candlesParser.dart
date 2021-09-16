import 'dart:convert';
import '../../../domain/rawCandle.dart';
class CandlesParser{
    static List<RawCandle> parse(String body){
        var decoded = jsonDecode(body);
        var candles = (decoded['data']['candles']);
        List<RawCandle> rawCandles = [];
        for(int i=0;i<candles.length;i++){
            rawCandles.add(create(candles[i]));
        }
       return rawCandles;
    }
    static double ifInt(data){
        if(data is int) return data.toDouble();
        return data;
    }
    static RawCandle create(data){
        var d = DateTime.parse(data[0].substring(0,19));
        double o = ifInt(data[1]);
        double h = ifInt(data[2]);
        double l = ifInt(data[3]);
        double c = ifInt(data[4]);
        return RawCandle(d,o,h,l,c);
    }
}
 