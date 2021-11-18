import '../instrument.dart';
class TraderMeta{
	final Instrument instrument;
	final int interval;
	TraderMeta(this.instrument,this.interval);
	String toString(){
		return '$instrument $interval';
	}
	@override
	bool operator==(o){
		if(o is TraderMeta) 
			return o.instrument == instrument 
			&& o.interval == interval;
		return false;
	}
	@override
	int get hashCode => Object.hash(instrument.hashCode,interval);
}