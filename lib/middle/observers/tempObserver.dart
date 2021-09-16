import '../../core/instrument.dart';
class Order{
    final double entry;
    final DateTime entryTime;
    double? exit;
    DateTime? exitTime;
    Order(this.entry,this.entryTime);
    exitOrder(double ltp){
        exit = ltp;
        exitTime = DateTime.now();
    }
    String toString(){
        if(exit == null) return '$entry $entryTime';
        else return '$entry $entryTime $exit $exitTime';
    }
}
class TempObserver{
    Order? order;
    final Instrument instrument;
    final void Function(String,String) notify;
    final void Function(int) exitCallback;
    TempObserver(this.instrument,this.notify,this.exitCallback);
    ltpChanged(double ltp,DateTime dateTime,bool isCandleChanged){
        if(order == null){
            order = Order(ltp,DateTime.now());
            notify('entrered'+instrument.name,order!.toString());
        }else{
            checkExit(ltp);
        }
    }
    checkExit(double ltp){
        print(order);
        if(ltp<=(order!.entry-30) || ltp>=(order!.entry+30)){
            order!.exitOrder(ltp);
            notify('exited'+instrument.name,order!.toString());
            exitCallback(instrument.token);
        }
    }
    
}
