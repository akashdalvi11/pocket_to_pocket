import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';
class WSWrapper {
  var _wsParser = WSParser();
  late Stream<Map<String,dynamic>> stream;
  late WebSocketChannel ws;
  DateTime? latest;
  static DateTime edgedDateTime(datetime,interval){
    return datetime.subtract(Duration(
        minutes:datetime.minute % interval,
        milliseconds: datetime.millisecond,
        microseconds: datetime.microsecond,
        seconds: datetime.second));
  }
  WSWrapper(this.ws, int interval) {
    stream = ws.stream.where((event){
      return _wsParser.isParsable(event);
    }).map((event) {
      var current = edgedDateTime(DateTime.now(),interval);
      var isCandleChanged = false;
      if(latest!= null){
        isCandleChanged = current != latest;
        if(isCandleChanged) latest = current;
      } else latest = current;
      return {'ltps': _wsParser.parseBinary(event), 'meta':{'date':current,'isChanged':isCandleChanged}};
    });
  }

  subscribe(int token) {
    ws.sink.add(jsonEncode({"a": "mode", "v": ["ltp",[token]]}));
  }

  unsubscribe(int token) {
    ws.sink.add(jsonEncode({"a": "unsubscribe", "v": [token]}));
  }

  close() {
    ws.sink.close();
  }
}


class WSParser {
  int segmentNseCD = 3;
  int segmentBseCD = 6;
  bool isParsable(Uint8List l){
    return l.length != 1;
  }
  int _buf2long(Uint8List t) {
    var s = 0;
    var i = t.length;
    for (var n = 0, r = i - 1; n < i; n++, r--) s += t[r] << 8 * n;
    return s;
  }
  Map<int,double> parsingDesired(List<Map<String,dynamic>> parsed){
    Map<int,double> map = {};
    for(var x in parsed){
      map[x['token']] = x['lastPrice'];
    }
    return map;
  }
  List<Uint8List> splitPackets(Uint8List e) {
    var t = _buf2long(e.sublist(0, 2));
    var s = 2;
    List<Uint8List> i = [];
    for (var o = 0; o < t; o++) {
      var n = _buf2long(e.sublist(s, s + 2));
      var r = e.sublist(s + 2, s + 2 + n);
      i.add(r);
      s += 2 + n;
    }
    return i;
  }

  Map<String, dynamic> calculateChange(Map<String, dynamic> e) {
    var t = 0.0;
    var s = 0.0;
    var i = 0.0;
    var n = 0.0;
    if (e['closePrice'] != null) {
      s = e['lastPrice'] - e['closePrice'];
      t = 100 * s / e['closePrice'];
    }
    if (e['openPrice'] != null) {
      i = e['lastPrice'] - e['openPrice'];
      n = 100 * i / e['openPrice'];
    }
    return {
      'change': t,
      'absoluteChange': s,
      'openChange': i,
      'openChangePercent': n
    };
  }

  Map<int,double> parseBinary(Uint8List e) {
    var t = this.splitPackets(e);
    List<Map<String, dynamic>> s = [];
    for (var i in t) {
      Map<String, dynamic> e;
      var t = _buf2long(i.sublist(0, 4));
      var n = 255 & t, r = 100;
      if (n == this.segmentNseCD)
        r = pow(10, 7).toInt();
      else if (n == this.segmentBseCD) r = pow(10, 4).toInt();
      if (8 == i.lengthInBytes) {
        s.add({
          'mode': 'ltp',
          'isTradeable': false,
          'token': t,
          'lastPrice': _buf2long(i.sublist(4, 8)) / r
        });
      } else if (12 == i.lengthInBytes) {
        e = {
          'mode': 'ltpc',
          'isTradeable': false,
          'token': t,
          'lastPrice': _buf2long(i.sublist(4, 8)) / r,
          'closePrice': _buf2long(i.sublist(8, 12)) / r
        };
        e.addAll(calculateChange(e));
        s.add(e);
      } else if (28 == i.lengthInBytes || 32 == i.lengthInBytes) {
        e = {
          'mode': 'modefull',
          'isTradeable': true,
          'token': t,
          'lastPrice': _buf2long(i.sublist(4, 8)) / r,
          'highPrice': _buf2long(i.sublist(8, 12)) / r,
          'lowPrice': _buf2long(i.sublist(12, 16)) / r,
          'openPrice': _buf2long(i.sublist(16, 20)) / r,
          'closePrice': _buf2long(i.sublist(20, 24)) / r
        };
        e.addAll(calculateChange(e));
        s.add(e);
      } else if (492 == i.lengthInBytes) {
        Map<String, dynamic> e = {
          'mode': 'modefull',
          'token': t,
          'extendedDepth': {'buy': [], 'sell': []}
        };
        var n = 0;
        var o = i.sublist(12, 492);
        for (var t = 0; t < 40; t++) {
          n = 12 * t;
          e['extendedDepth'][t < 20 ? "buy" : "sell"].push({
            'quantity': _buf2long(o.sublist(n, n + 4)),
            'price': _buf2long(o.sublist(n + 4, n + 8)) / r,
            'orders': _buf2long(o.sublist(n + 8, n + 12))
          });
        }
        s.add(e);
      } else {
        e = {
          'mode': 'modequote',
          'token': t,
          'isTradeable': false,
          'volume': _buf2long(i.sublist(16, 20)),
          'lastQuantity': _buf2long(i.sublist(8, 12)),
          'totalBuyQuantity': _buf2long(i.sublist(20, 24)),
          'totalSellQuantity': _buf2long(i.sublist(24, 28)),
          'lastPrice': _buf2long(i.sublist(4, 8)) / r,
          'averagePrice': _buf2long(i.sublist(12, 16)) / r,
          'openPrice': _buf2long(i.sublist(28, 32)) / r,
          'highPrice': _buf2long(i.sublist(32, 36)) / r,
          'lowPrice': _buf2long(i.sublist(36, 40)) / r,
          'closePrice': _buf2long(i.sublist(40, 44)) / r
        };
        e.addAll(calculateChange(e));

        if (164 == i.lengthInBytes || 184 == i.lengthInBytes) {
          var t = 44;
          if (184 == i.lengthInBytes) t = 64;
          var s = t + 120;
          e['mode'] = 'modefull';
          e['depth'] = {'buy': [], 'sell': []};
          if (184 == i.lengthInBytes) {
            var t = _buf2long(i.sublist(44, 48));
            e['lastTradedTime'] = null;
            e['oi'] = _buf2long(i.sublist(48, 52));
            e['oiDayHigh'] = _buf2long(i.sublist(52, 56));
            e['oiDayLow'] = _buf2long(i.sublist(56, 60));
          }
          var n = 0, o = i.sublist(t, s);
          for (var i = 0; i < 10; i++) {
            n = 12 * i;
            e['depth'][i < 5 ? "buy" : "sell"].push({
              'price': _buf2long(o.sublist(n + 4, n + 8)) / r,
              'orders': _buf2long(o.sublist(n + 8, n + 10)),
              'quantity': _buf2long(o.sublist(n, n + 4))
            });
          }
        }
        s.add(e);
      }
    }
    return (parsingDesired(s));
  }
}

