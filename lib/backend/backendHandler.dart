import 'handlers/tokensHandler.dart';
import 'handlers/wsWrapper.dart';
import 'handlers/endPoint.dart';
import 'handlers/candlesParser.dart';
import '../../core/rawCandle.dart';
class BackendHandler{
    final EndPoint _endPoint = EndPoint();
    late TokensHandler tokensHandler;
    late WSWrapper wsWrapper;
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