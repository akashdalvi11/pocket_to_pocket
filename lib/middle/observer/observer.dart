import 'dart:async';
import '../../core/dataForest/dataSpecForest.dart';
import '../../core/dataForest/dataForest.dart';
import '../../core/dataForest/dataForestCreator.dart';
import '../../core/signal.dart';
import '../../core/analyser.dart';
class Observer{
    final DataSpecForest dataSpecForest;
    final Stream<Map<String,dynamic>> inputStream;
    final Function(Signal) signalCallback;
    DataForest? dataForest;
    final Analyser analyser = Analyser();
    Observer(this.dataSpecForest,this.inputStream,this.signalCallback){
        startListening();
    }
    startListening(){
        inputStream.listen((Map<String,dynamic> event){
            if(event['historical']){
                    dataForest = DataForestCreator.createDataForest(dataSpecForest,event['data']);
                    checkSignal();
            }else{
                if(dataForest!.update(event['data'])){
                    checkSignal();
                }
            }
        });
    }
    checkSignal(){
        Signal? signal = analyser.update(dataForest!);
        if(signal!= null) signalCallback(signal);
    }
}
