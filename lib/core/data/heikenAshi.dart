import 'dart:math';
class HeikenAshi extends OHLC{
    final o,h,l,c;
    HeikenAshi(OHLC ohlc,this.o,this.h,this.l,this.c): ohlc;
    static List<HeikenAshi> fromOHLC(List<OHLC> list){
        var hlist = <HeikenAshi>[];
        hlist.add(HeikenAshi(list[0],list[0].o,.....));
        for(int i=1;i<list.length;i++){
            var c = list[i];
            var close = (c.o+c.h+c.l+c.c)/4
            var open = (hlist[i-1].o + hlist[i-1].c)/2
            var high = max(c.h,max(close,open))
            var low = min(c.l,min(close,open))
            hlist.add(HeikenAshi(list[i],open,close,high,low));
        }
        return l;
    }
    @override
    HeikenAshi updated(double ltp){
        var close = super.o+super.h+super.l+ltp)/4;
        var high = max(this.o,max(this.h,close));
        var low = min(this.o,min(this.l,close));
        return HeikenAshi(super,this.o,high,low,close);
    }
}
class HeikenAshiEMA extends HeikenAshi with EMA{
    HeikenAshiEMA(HeikenAshi h):h;
    static createList(List<OHLC> list){
        var hList = super.createList(list);
        var values = <double>[];
        for(var x in hList) values.add(x.c);
        var hEMAList = <HeikenAshiEMA>[];
        for(var x in hList) hEMAList.add(HeikenAshiEMA(h));
        EMAHelper.assignEMA(hEMAList,values,10);
    }
    @override updated(double ltp){
        var new = HeikenAshiEMA(super.updated(ltp));
        new.setUpdatedEMA(super.ema,ltp);
        return new;
    }
    justFormed()
}