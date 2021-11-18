import 'dart:async';
// import 'dart:math';
import '../lib/core/traderMeta/traderMeta.dart';
import '../lib/core/instrument.dart';
import '../lib/core/traderMeta/historicalTraderMeta.dart';
void main() async {
   var l = <Something>[];
   if(l.last.doit() == 5 &&l.length !=0){
    print('whtaer');
   }
}
class Something{
    Something(this.a);
    final int a;
    doit(){
        return a;
    }
}
