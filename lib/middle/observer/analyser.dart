import '../../core/indicator/indicatorForest.dart';
Signal? tempAnalyser(){
            var candleHeight = c.h - c.l;
        var upperLimit = c.l + (candleHeight/4);
        var lowerLimit = c.h - (candleHeight/4);
        return c.ema < upperLimit ? 
            IndicatorState.up : c.ema > lowerLimit ?
            IndicatorState.down : IndicatorState.none;
}