import 'parsers/instrumentParser.dart';
import 'handlers/historicalDataParser.dart';
import 'endpoints/zerodhaEndPoint.dart';
import 'endpoints/FirebaseEndpoint.dart';
import 'historicalAndLiveSync.dart';
import '../core/instrument.dart';
class BackendHandler{
    final ZerodhaEndPoint _zerodhaEndPoint = ZerodhaEndPoint();
    final FirebaseEndpoint _firebaseEndpoint = FirebaseEndpoint();
    late List<Instrument> _instruments;
    Map<int,dynamic> streams = {};
    Future<String?> init() async{
        var error = await _zerodhaEndPoint.login();
        if(error != null) return error;
        var instrumentsRaw = await _zerodhaEndPoint.getInstruments();
           return instrumentsRaw.fold((l)=>l.toString(),(r) async{
                _instruments = await InstrumentParser.parse(r);
                _zerodhaEndPoint.setWSChannel();
        });
    }
    List<Instrument> getOptions(String name,DateTime expiry){
        var filtered = <Instrument>[];
        for(var x in instruments){
            if(x.name.contains(name+'${expiry.year-2000}${expiry.month}${expiry.day}')) filtered.add(x);
        }
        return filtered;
    }
    _listenToWS(){
        _zerodhaEndPoint.wsWrapper.stream.listen((event){
            if(WSParser.isParsable(event)){
                var parsed = WSParser.parseBinary(event);
                var dateTime = DateTime.now();
                for (var x in parsed.keys){
                    parsed[x]['data']['dateTime'] = dateTime;
                    parsed[x]['historical'] = false;
                    streams[x].add(parsed[x]);
                }
            }
        })
    }
    Future<List<dynamic>?> _getHistoricalData(int token,int interval) async{
        return (await _endPoint.getHistoricalData(token,interval)).fold((l)=>null,(r){
            return HistoricalDataParser.parse(r);
        });
    }
    Stream<Map<String,dyanmic>> getStream(int token,List<int> intervals){
        var s = StreamController<Map<String,dynamic>>();
        var historicalAndLiveSync = HistoricalAndLiveSync(intervals[0],()=>_getHistoricalData(token,intervals[0]),(){
            getIt<UIAdapter>().sendError("cannot fetch ${i}");
        },(data,dateTime,ohlc){
            var combinedList = HistoricalDataParser.parse(data);
            combinedList[0].add(dateTime);
            combinedList[1].add(ohlc);
            s.add({'historical':true,'data':{intervals[0]:combinedList});
            streams[token] = s;
        });
        streams[token] = historicalAndLiveSync;
        _zerodhaEndPoint.wsWrapper.subscribe(token);
        return s.stream;
    }
}