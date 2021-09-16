// import 'dart:async';
// import 'dart:convert';

// void main(){
//     Candle c = Candle(4,5,3,5,3);
//     print(c);
//     AverageCandle average = AverageCandle(4,5,3,4,2,c);
//     print(average);
// }
// class Candle{
//     final DateTime dateTime;
//     final double o,h,l,c,ema;
//     Candle(this.o,this.h,this.l,this.c,this.ema);
//     Candle.create(this.ema,RawCandle rawCandle):
//     this.dateTime = rawCandle.dateTime,
//         this.o = rawCandle.o,
//         this.h = rawCandle.h,
//         this.l = rawCandle.l,
//         this.c = rawCandle.c;
// }
// class AverageCandle{
//     final double ho,hh,hl,hc,ema;
//     final Candle candle;
//     AverageCandle(this.candle,this.ho,this.hh,this.hl,this.hc,this.ema);
// }