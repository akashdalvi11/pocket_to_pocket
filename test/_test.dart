import 'dart:async';
// import 'dart:math';
import '../lib/core/observerMeta/observerMeta.dart';
import '../lib/core/instrument.dart';
import '../lib/core/observerMeta/historicalObserverMeta.dart';
void main() async {
    var i = Instrument(4334,"whatever");
    var x = Instrument(4334,"whatever");
    print('instrument');
    print(x.hashcode);
    print(i.hashcode);
    print(x==i);
    var omi = ObserverMeta(i,5);
    var omx = ObserverMeta(x,5);
    print(omi.hashcode);
    print(omx.hashcode);
    print(omi==omx);
    var homi = HistoricalObserverMeta(i,5,DateTime.now());
    var homx = HistoricalObserverMeta(x,5,DateTime.now());
    print(homi.hashcode);
    print(homx.hashcode);
    print(homi==homx);
}

class Backend{
    final streams = <int,StreamController>{};
    final ws;
    StreamHandler(this.ws){
        listenToWebSocket();
    }
    listenToWebSocket(){
        ws.listen((e){
           streams[e['index']].add(e['data']);
        });
    }
    getStream(int index){
        var s = StreamController();
        streams[index] = s;
        return s.stream;
    }
}
class StreamListenerHandler{
    Map<int,StreamListener> listeners = {};
    addListener(int index){
        map[index] = listeners;
    }
}
class StreamListener{
    final int index;
    StreamListener(this.index){
        startListening();
    }
    startListening(){
        getIt<Backend>().getStream().listen((data){
            //do stuff
        });
    }
}
void main(){
    var handler = StreamListenerHandler();
    handler.addListener(5);
    // after some time...
    handler.addListener(5);
}