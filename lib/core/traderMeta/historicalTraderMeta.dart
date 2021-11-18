import 'traderMeta.dart';
import '../instrument.dart';

class HistoricalTraderMeta extends TraderMeta{
	final DateTime from;
	HistoricalTraderMeta(Instrument i,int interval,this.from):super(i,interval);
	String toString(){
		return 'historical - ${super.toString()} - $from';
	}
	@override
	bool operator==(o){
		if(o is HistoricalTraderMeta) 
			return o.instrument == super.instrument 
			&& o.interval == super.interval 
			&& o.from == from;
		return false;
	}
	@override
	int get hashCode => Object.hash(super.hashCode,from);
}