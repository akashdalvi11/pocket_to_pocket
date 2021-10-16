class Signal{
    final DateTime dateTime;
    final SignalType signalType;
    Signal(this.dateTime,this.signalType);
}
enum SignalType{up,down,sideways};