import 'data/interfaceData/ohlc.dart';
import 'data/ema.dart';
import 'data/sma.dart';
import 'data/stochastic.dart';
import 'data/heikenAshi.dart';
import 'dataForest/dataForest.dart';
import 'signal.dart';
import 'analyserInference.dart';
class Analyser{
	late AnalyserInference analyserInference;
	bool isInitialised = false;
	static bool _isStateSimilar(HeikenAshi h,EMA e,int inferedState){
		return h.c * inferedState > e.value * inferedState;
	}
	static bool approxEqual(double a,double b){
		var l = a-1;
		var h = a+1;
		return b<h && b>l;
	}
	static AnalyserInference? _checkInference(HeikenAshi h,EMA e,SMA pK,SMA pD){
		var bound = h.o + (h.c - h.o)/4;
		if(h.c>e.value){
			if(pK.value > 50 && pD.value > 50) 
				if(approxEqual(h.o,h.l))
					if(e.value<bound){
					return AnalyserInference.up;
					}
		}else{
			if(pK.value < 50 && pD.value < 50)
				if(approxEqual(h.o,h.h)){
					if(e.value>bound){
					return AnalyserInference.down;
					}
				}
		}
	}
	static AnalyserInference? _checkInferenceBackWords(int inferedState,List<HeikenAshi> hl,List<EMA> el,List<SMA> kl,List<SMA> dl,int index){
		for(int i=index;i>=0;i--){
			var h = hl[i];
			var e = el[i];
			var pK = kl[i];
			var pD = dl[i];
			if(_isStateSimilar(h,e,inferedState)){
				var i = _checkInference(h,e,pK,pD);
				if(i!=null) return i;
			}else return null;
		}
	}
	Signal? _initialise(List<HeikenAshi> hl,List<EMA> el,List<SMA> kl,List<SMA> dl,DateTime dateTime,double ltp){
		isInitialised = true;
		var sl = hl.length-2;
		var h = hl[sl];
		var e = el[sl];
		print("$dateTime $h $e");
		var inferedState = h.c > e.value?1:-1;
		var i = _checkInference(h,e,kl[sl],dl[sl]);
		var b =_checkInferenceBackWords(inferedState,hl,el,kl,dl,sl-1);
		if(i != null){
			analyserInference = i;
			if(b == null) return Signal(dateTime,i,ltp);
		}else{
			if(b != null) analyserInference = b;
			else analyserInference = AnalyserInference.sideways;
		}
		print(analyserInference);
	}
	Signal? update(DataForest f){
		var ltp = (f.trees[0].list.last as OHLC).c;
		var hl = f.trees[0].children[0].list.cast<HeikenAshi>();
		var el = f.trees[0].children[0].children[0].list.cast<EMA>();
		var stl = f.trees[0].children[0].children[1].list.cast<Stochastic>();
		var kl = f.trees[0].children[0].children[1].children[0].list.cast<SMA>();
		var dl = f.trees[0].children[0].children[1].children[0].children[0].list.cast<SMA>();
		var sl = f.list.length -2;
		var dateTime = f.list.last;
		// for(int i=0;i<f.list.length;i++){
		// 	var h = hl[i];
		// 	var e = el[i];
		// 	var pK = kl[i];
		// 	var pD = dl[i];
		// 	var st = stl[i];
		// 	print("${f.list[i]} $h $e $st $pK $pD");
		// }	
		if(!isInitialised){
			return _initialise(hl,el,kl,dl,dateTime,ltp);
		}
		var h = hl[sl];
		var e = el[sl];
		var st = stl[sl];
		var pK = kl[sl];
		var pD = dl[sl];
		print("$dateTime $h $e $st $pK $pD");
		if(analyserInference != AnalyserInference.sideways){
			if(!_isStateSimilar(h,e,analyserInference == AnalyserInference.up?1:-1)){
				analyserInference = _checkInference(h,e,pK,pD)??AnalyserInference.sideways;
				return Signal(dateTime,analyserInference,ltp);
			}
		}else{
			var i = _checkInference(h,e,pK,pD); 
			if(i!=null){
				analyserInference = i;
				return Signal(dateTime,analyserInference,ltp);
			}
		}
		
	}
}
