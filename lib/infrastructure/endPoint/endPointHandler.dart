import 'parsers/tokensHandler.dart';
import 'parsers/wsWrapper.dart';
import 'endPoint.dart';
import 'parsers/candlesParser.dart';
import '../../domain/rawCandle.dart';
class EndPointHandler{
    final EndPoint _endPoint;
    late TokensHandler tokensHandler;
    late WSWrapper wsWrapper;
    EndPointHandler(this._endPoint);
    Future<String?> init() async{
        var error = await _endPoint.login();
        if(error != null) return error;
        var tokensTemp = await _endPoint.getTokens();
           return tokensTemp.fold((l)=>l.toString(),(r) async{
                tokensHandler = await TokensHandler.create(r);
                wsWrapper = WSWrapper(_endPoint.getWS(),5);
        });
    }
    Future<List<RawCandle>?>getCandles(token) async{
        return (await _endPoint.getCandles(token)).fold((l)=>null,(r){
            return CandlesParser.parse(r);
        });
    }
    EndPoint test(){
        return _endPoint;
    }
}