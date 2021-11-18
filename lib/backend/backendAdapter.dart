import 'dart:async';
import '../core/instrument.dart';
import '../core/traderMeta/traderMeta.dart';
import '../injector.dart';
import '../middle/globals.dart';
import '../ui/uiAdapter.dart';
import 'endpoints/zerodhaEndPoint.dart';
import 'endpoints/FirebaseEndpoint.dart';
import 'parsers/instrumentParser.dart';
import 'parsers/historicalDataParser.dart';
import 'parsers/wsParser.dart';
import 'intervalStream.dart';
class BackendAdapter {
    final ZerodhaEndPoint _zerodhaEndPoint = ZerodhaEndPoint();
    final FirebaseEndpoint _firebaseEndpoint = FirebaseEndpoint();
    late List<Instrument> _instruments;
    Map<int, Map<int,IntervalStream>> streams = {};
    Future<String?> init() async {
        var error = await _zerodhaEndPoint.login();
        if (error != null) return error;
        var instrumentsRaw = await _zerodhaEndPoint.getInstruments();
        return instrumentsRaw.fold((l) => l.toString(), (r) async {
            _instruments = await InstrumentParser.parse(r);
            _zerodhaEndPoint.setWSChannel();
            _listenToWS();
        });
    }

    // sendSignals(TraderMeta m,Signal s) {
    //     _firebaseEndpoint.addCurrentTimestamp();
    // }

    List<Instrument> getOptions(String name, DateTime expiry) {
        var filtered = <Instrument>[];
        for (var x in _instruments) {
            if (x.name
                    .contains(name + '${expiry.year - 2000}${expiry.month}${expiry.day}'))
                filtered.add(x);
        }
        return filtered;
    }

    _listenToWS() {
        _zerodhaEndPoint.wsWrapper.stream.listen((event) {
            if (WSParser.isParsable(event)) {
                var parsed = WSParser.parseBinary(event);
                var dateTime = DateTime.now();
                for (var x in streams.keys) {
                    parsed[x]['data']['dateTime'] = dateTime;
                    for(var y in streams[x]!.keys){
                    streams[x]![y]!.add(parsed[x]);
                    }
                }
            }
        });
    }

    Future<List<dynamic>?> getHistoricalData(int token, int interval) async {
        var fromDate = getIt<Globals>().historicalBufferStart;
        return (await _zerodhaEndPoint.getHistoricalData(token, interval,fromDate,DateTime.now()))
                .fold((l) => null, (r) {
            var parsed =    HistoricalDataParser.parse(r);
            return parsed;
        });
    }
    
    Stream<Map<String, dynamic>> getStream(
            int token, int interval) {
        var intervalStream = IntervalStream(interval, () => getHistoricalData(token, interval));
        if(!streams.containsKey(token)){
            _zerodhaEndPoint.wsWrapper.subscribe(token);
            streams[token] = {};
        }
        streams[token]![interval] = intervalStream;
        print(streams);
        return intervalStream.streamController.stream;
    }
    Future<void> disposeStream(int token,int interval) async{
        if(streams[token]!.keys.length == 1){
            _zerodhaEndPoint.wsWrapper.unsubscribe(token);
            streams.remove(token);
        }else streams[token]!.remove(interval);
        print(streams);
    }
}
