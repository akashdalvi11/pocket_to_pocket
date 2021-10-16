
class WSParser {
  int segmentNseCD = 3;
  int segmentBseCD = 6;
  static bool isParsable(l){
    if(l is Uint8List) return l.length != 1;
    print(l);
    print("not parsable wrong wrong wrong");
    return false;
  }
  static int _buf2long(Uint8List t) {
    var s = 0;
    var i = t.length;
    for (var n = 0, r = i - 1; n < i; n++, r--) s += t[r] << 8 * n;
    return s;
  }
  
  static List<Uint8List> _splitPackets(Uint8List e) {
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

  static Map<String, dynamic> _calculateChange(Map<String, dynamic> e) {
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
  static Map<int,dynamic> parsingDesired(List<Map<String,dynamic>> list){
    var map = <int,dynamic>{};
    for(var x in list){
      map[x['token']] = {'data':{'ltp':x['lastPrice']}}; 
    }
    return map;
  }
  static Map<int, dynamic> parseBinary(Uint8List e) {
    var t = this._splitPackets(e);
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
        e.addAll(_calculateChange(e));
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
        e.addAll(_calculateChange(e));
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
        e.addAll(_calculateChange(e));

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
    return parsingDesired(s);
  }
  
}
