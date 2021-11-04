import 'data.dart';

class SMA extends Data {
  final double value;
  SMA(this.value);
  static SMA getSMA(List<double> values) {
    double sma = 0;
    for(var i=0;i<values.length;i++)
      sma+= values[i];
    return SMA(sma/values.length);
  }

  static List<SMA> getSMAList(List<double> values, int period) {
    List<SMA> SMAs = [];
    for(var i=0;i<period-1;i++){
      SMAs.add(SMA(0));
    }
    for (var i = period-1; i < values.length; i++) {
      SMAs.add(
        getSMA(
          values.sublist(i-(period-1),i+1)
        )
      );
    }
    return SMAs;
  }
  String toString(){
    return "$value";
  }
}
