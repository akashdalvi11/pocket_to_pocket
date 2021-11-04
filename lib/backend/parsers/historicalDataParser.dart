import 'dart:convert';
import '../../../core/data/interfaceData/ohlc.dart';

class HistoricalDataParser {
  static List<dynamic> parse(String body) {
    var decoded = jsonDecode(body);
    var candles = (decoded['data']['candles']);
    List<OHLC> ohlcList = [];
    List<DateTime> timeFrameList = [];
    for (int i = 0; i < candles.length; i++) {
      var data = candles[i];
      timeFrameList.add(createTimeFrame(data[0]));
      ohlcList.add(createOHLC(data));
    }
    return [timeFrameList, ohlcList];
  }

  static DateTime createTimeFrame(dateTimeString) {
    return DateTime.parse(dateTimeString.substring(0, 19));
  }

  static OHLC createOHLC(data) {
    double o = ifInt(data[1]);
    double h = ifInt(data[2]);
    double l = ifInt(data[3]);
    double c = ifInt(data[4]);
    return OHLC(o, h, l, c);
  }

  static double ifInt(intOrDouble) {
    if (intOrDouble is int) return intOrDouble.toDouble();
    return intOrDouble;
  }
}
