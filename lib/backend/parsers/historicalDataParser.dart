import 'dart:convert';
import '../../../core/timeFrame.dart';
import '../../../core/data/ohlc.dart';
class HistoricalDataParser{
    static List<dynamic> parse(String body){
        var decoded = jsonDecode(body);
        var candles = (decoded['data']['candles']);
        List<OHLC> ohlcList = [];
        List<TimeFrame> timeFrameList = [];
        for(int i=0;i<candles.length;i++){
            timeFrameList.add(createTimeFrame(data[0]));
            ohlcList.add(createOHLC(data[1],data[2],data[3],data[4]));
        }
       return [timeFrameList,ohlcList];
    }
    static TimeFrame createTimeFrame(data){
        return TimeFrame(DateTime.parse(data.substring(0,19));
    }
    static OHLC createOHLC(data){
        double o = ifInt(data[1]);
        double h = ifInt(data[2]);
        double l = ifInt(data[3]);
        double c = ifInt(data[4]);
        return OHLC(o,h,l,c);
    }
    static double ifInt(data){
        if(data is int) return data.toDouble();
        return data;
    }
}
 