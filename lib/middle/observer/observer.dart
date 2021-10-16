import '../../core/indicator/indicatorForest.dart';
import '../../core/indicator/indicatorSpecForest.dart';
import '../../core/signal.dart';
import 'analyser.dart';
class Observer{
    final Instrument instrument;
    final Map<int,DataSpecForest> dataSpecForests;
    final Stream<Map<String,dynamic>> inputStream;
    final Function(Map<int,Signal>) signalCallback;
    Map<int,DataForest> dataForests = {};
    Observer(this.instrument,this.dataSpecForests,this.inputStream,this.signalCallback){
        startListening();
    }
    startListening(){
        inputStream.listen((Map<String,dynamic> event){
            if(event['historical']){
                for(var x in event['data'].keys){
                    dataForests[x] = createForest(dataSpecForests[x]!,event['data'][x]);
                }
            }else{
                Map<int,Signal> signal = [];
                for(var x in event['data'].keys){
                    dataForests[x]!.update(event['data'][x]);
                    Signal? signal = tempAnalyser(dataForests[x]!);
                    if(signal!=null) signals[x] = (signal);
                }
                if(signals.keys.length != 0) sendSignals(signals);
            }
        })
    }
}
