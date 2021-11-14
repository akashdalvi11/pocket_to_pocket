import '../instrument.dart';
class ObserverMeta{
	final Instrument instrument;
	final int interval;
	ObserverMeta(this.instrument,this.interval);
	String toString(){
		return '$instrument $interval';
	}
	@override
	bool operator==(o){
		if(o is ObserverMeta) 
			return o.instrument == instrument 
			&& o.interval == interval;
		return false;
	}
	@override
	int get hashCode => Object.hash(instrument.hashCode,interval);
}