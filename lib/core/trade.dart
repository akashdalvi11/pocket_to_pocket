import 'order.dart';
import 'instrument.dart';
class Trade{
	final Instrument instrument;
	final Order entry;
 	late final Order exit;
 	Trade(this.instrument,this.entry);
 	bool _isDone = false;
 	bool get isDone => _isDone;
 	String toString(){
 		String e = _isDone?'$exit':'not exited';
 		return '$instrument $entry $e';
 	}
 	addExit(Order o){
 		exit = o;
 		_isDone	= true;
 	}
}