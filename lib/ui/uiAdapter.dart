import 'package:flutter/material.dart';
import '../middle/observerHandler.dart';
import '../injector.dart';
import '../backend/backendHandler.dart';
class UIAdapter extends ChangeNotifier {
  var message = 'press it';
  String s = "";
  late ObserverHandler o;
  initializeBackend(){
    getIt<BackendHandler>().init();
  }
  test() async{
    o = ObserverHandler();
    o.addObserver([260105]);
    // var list = getIt<EndPointHandler>().tokensHandler.getOptionTokens('BANKNIFTY',DateTime.now());
    // var ltp = 36633;
    //   for(var x in list){
    //     if(x.name.contains((ltp-(ltp%100)).toString())){
    //         print(x);
    //         break;
    //     }
    //   }
    // getIt<EndPointHandler>().wsWrapper.close();
    // var candles = getIt<EndPointHandler>().test().getCandles(260105);
    // print(await candles);
    // print(DateTime.now().subtract(Duration(days:30)).toString().substring(0,10));
    // var rawCandles = (await getIt<EndPointHandler>().getCandles(260105))??[];
    // candles = Candle.createList(rawCandles);
    // for(var x in candles){
    //   print(x);
    // }
    // var datetime = DateTime.parse("2021-06-30T09:15:00");
    // print(DateTime.now());
    // print(getIt<EndPointHandler>().tokensHandler.instruments);
    // s = (await getIt<EndPointHandler>().test().getTokens()).fold((l)=>l.toString(),(r)=>r);
    // print(s);
    // list = (CsvToListConverter(eol:'\n').convert(s));
    // var instruments = <List<int>>[];
    //     for(var x in list){
    //         instruments.add([x[0],x[2]]);
    //     }
    //     print(instruments);
    
  
  }
}
