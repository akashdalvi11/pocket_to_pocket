class EMAHelper{
    static double calculateEMA(previousEMA,newValue,alpha){
        if(previousEMA == 0) return 0.0;
        return (previousEMA + alpha*(newValue - previousEMA));
    }
    static assignEMA(List<EMA> emaTimeFrames,List<double> values,double range){
        alpha = 2/(range+1);
        double sma = 0;
        emaTimeFrames[0].ema = 0;
        for(var i=1;i<values.length;i++){
            if(i<range-1) sma += values[i];
            emaTimeFrames[i].ema = i==9?sma/10:calculateEMA(emaTimeFrames[i-1].ema,values[i],alpha);
        }
    }
}
mixin EMA {
    late final double ema;
    setUpdatedEMA(double alpha,double oldEMA,double oldValue,double newValue){
        return oldEMA - alpha*(oldValue-newValue);
    }
}