import 'analyserInference.dart';
class Signal {
  final DateTime dateTime;
  final AnalyserInference analyserInference;
  final double value;
  Signal(this.dateTime,this.analyserInference,this.value);
  String toString(){
    return '$dateTime : $analyserInference : $value';
  }
}

