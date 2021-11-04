import 'dart:async';
import 'dart:convert';
import 'package:client_cookie/client_cookie.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../core/errors.dart';
import 'wsWrapper.dart';

class ZerodhaEndPoint {
  var _cookies = CookieStore();
  String _userID = 'KF3482';
  String _password = 'callofart137';
  String _twoFA = '137505';
  String _host = 'kite.zerodha.com';
  static const Map<int, String> intervalMap = {
    1: 'minute',
    2: '2minute',
    3: '3minute',
    4: '4minute',
    5: '5minute',
    10: '10minute',
    15: '15minute',
    30: '30minute',
    60: '60minute',
    120: '2hour',
    180: '3hour',
    360: 'day'
  };
  late String _enctoken;
  late WSWrapper wsWrapper;

  static String? _directivesParser(String? setCookie) {
    if (setCookie == null)
      return null;
    else {
      var toReturn = setCookie;
      var map = {'secure': 'Secure', 'path': 'Path', 'domain': 'Domain'};
      for (var x in map.keys) {
        toReturn = toReturn.replaceAll(x, map[x]!);
      }
      return toReturn;
    }
  }

  Future<Either<Errors, http.Response>> _makeRequest(Uri uri,
      {String requestMethod = 'post',
      Map<String, String>? body,
      Map<String, String>? headersPar}) async {
    print(uri);
    try {
      var r = http.Request(requestMethod, uri);
      if (requestMethod == 'post') {
        r.bodyFields = body!;
      }
      var headers = headersPar ??
          (_cookies.cookies.length == 0
              ? null
              : {'cookie': _cookies.toReqHeader});
      if (headers != null) r.headers.addAll(headers);
      http.StreamedResponse response = await r.send();
      if (response.statusCode == 200) {
        var responseWithBody = await http.Response.fromStream(response);
        _cookies.addFromHeader(
            _directivesParser(responseWithBody.headers['set-cookie']));
        return right(responseWithBody);
      } else {
        var responseWithBody = await http.Response.fromStream(response);
        print(responseWithBody.body);
        return left(Errors.sessionExpired);
      }
    } catch (e) {
      print(e);
      return left(Errors.networkError);
    }
  }

  Future<String?> login() async {
    var loginResponse = await _makeRequest(
        Uri.parse('https://kite.zerodha.com/api/login'),
        body: {'user_id': _userID, 'password': _password});
    return loginResponse.fold((l) {
      return errorHandler(l);
    }, (r) async {
      var requestID = jsonDecode(r.body)['data']['request_id'];
      var twofaResponse = await _makeRequest(
          Uri.parse('https://kite.zerodha.com/api/twofa'),
          body: {
            'user_id': _userID,
            'request_id': requestID,
            'twofa_value': _twoFA
          });
      return twofaResponse.fold((l) {
        return errorHandler(l);
      }, (r) async {
        _enctoken = _cookies.cookieMap['enctoken']!.value;
      });
    });
  }

  setWSChannel() {
    var uri = Uri(host: "ws.zerodha.com", scheme: 'wss', queryParameters: {
      'api_key': 'kitefront',
      'user_id': _userID,
      'enctoken': _enctoken
    });
    wsWrapper = WSWrapper(WebSocketChannel.connect(uri));
  }

  Future<Either<Errors, dynamic>> getInstruments() async {
    var url = "https://api.kite.trade/instruments";
    final cacheFile = await DefaultCacheManager().getFileFromCache(url);
    var file;
    try {
      if (cacheFile != null) {
        if (cacheFile.validTill.isBefore(DateTime.now())) {
          var fileInfo = await DefaultCacheManager().downloadFile(url,
              key: url,
              authHeaders: {'authorization': 'enctoken ' + _enctoken});
          file = fileInfo.file;
        }
        file = cacheFile.file;
      }
      file = (await DefaultCacheManager().downloadFile(url,
              key: url,
              authHeaders: {'authorization': 'enctoken ' + _enctoken}))
          .file;
      return right(file);
    } catch (_) {
      print(_);
      return left(Errors.networkError);
    }
  }

  static String getDate(DateTime dateTime) {
    return dateTime.toString().substring(0, 10);
  }

  Future<Either<Errors, String>> getHistoricalData(
      int token, int interval,DateTime from, DateTime to) async {
    var uri = Uri(
        host: _host,
        scheme: 'https',
        path: 'oms/instruments/historical/$token/${intervalMap[interval]}',
        queryParameters: {
          'from':getDate(from),
          'to': getDate(to),
          'user_id': _userID,
        });
    var chartResponse = await _makeRequest(uri,
        requestMethod: 'get',
        headersPar: {'authorization': 'enctoken ' + _enctoken});
    return chartResponse.fold((l) => left(l), (r) => right(r.body));
  }

  test() async {
    // var data = (await getC(260105)).fold((l)=>l.toString(),(r)=>r.body);
    // OldDataParser.parse(data);
    //var observer = AssetObserver.create(260105,data,(String s){    });
  }
}
