import 'dart:async';
import '../dataForest/dataSpecForest.dart';
import '../dataForest/dataForest.dart';
import '../dataForest/dataForestCreator.dart';
import '../trade.dart';
import '../order.dart';
import '../analyser.dart';
class Trader{
    final DataSpecForest dataSpecForest;
    final Stream<Map<String,dynamic>> inputStream;
    final List<Trade> trades;
    final Function(Order) addTrade;
    final Function(Order) exitTrade;
    DataForest? dataForest;
    final Analyser analyser = Analyser();
    Trader(this.dataSpecForest,this.inputStream,this.trades,this.addTrade,this.exitTrade){
        startListening();
    }
    startListening(){
        inputStream.listen((Map<String,dynamic> event){
            if(event['historical']){
                    dataForest = DataForestCreator.createDataForest(dataSpecForest,event['data']);
                    trade(event['data']['dateTime'],event['data']['ltp']);

            }else{
                if(dataForest!.update(event['data'])){
                    trade(event['data']['dateTime'],event['data']['ltp']);
                }
            }
        });
    }
    getOrderType(AnalyserInference ai){
        assert(ai != AnalyserInference.sideways);
        return ai == AnalyserInference.up?OrderType.buy:OrderType.sell;
    }
    trade(DateTime dateTime,double ltp){
        AnalyserInference? analyserInference = analyser.update(dataForest!);
        if(analyserInference!= null){
            if(trades.length==0 || trades.last.isDone){
                if(analyserInference != AnalyserInference.sideways){
                    addTrade(Order(getOrderType(analyserInference),dateTime,ltp));
                }
            }else{
                exitTrade(Order(trades.last.entry.orderType == OrderType.buy?OrderType.sell:OrderType.buy,dateTime,ltp));
                if(analyserInference != AnalyserInference.sideways){
                    assert(trades.last.exit.orderType != getOrderType(analyserInference));
                    addTrade(Order(getOrderType(analyserInference),dateTime,ltp));
                }
            }
        }   
    }
}
