import '../core/data/OHLC.dart';
class HistoricalAndLiveSync{
    final int interval;
    final Future<List<dynamic>?> Function() getData;
    final void Function() onError;
    final void Function(List<dynamic>,DateTime,OHLC) giveData;
    late OHLC ohlc;
    DateTime? latestDateTime;
    bool ohlcNull = true;
    bool isStarted = false;
    DateTime edgedDateTime(datetime){
        return datetime.subtract(Duration(
            minutes:datetime.minute % interval,
            milliseconds: datetime.millisecond,
            microseconds: datetime.microsecond,
            seconds: datetime.second));
    }
    HistoricalAndLiveSync(this.interval,this.getData,this.onError,this.giveData);
    add(Map<String,dynamic> map){
        DateTime dateTime = edgedDateTime(map['dateTime']);
        if(!isStarted){
            if(latestDateTime == null) latestDateTime = dateTime;
            else{
                if(dateTime != latestDateTime) isStarted = true;
            }
        }
        if(isStarted){
            if(ohlcNull){
                ohlc = OHLC.justFormed(map['data']['ltp']);
                ohlcNull = false;
                loadData();
            }else if(latestDateTime == dateTime){
                ohlc =  ohlc.updated(map['data']['ltp']);
            }else{
                loadData();
                latestDateTime = dateTime;
                ohlcNull = OHLC.justFormed(map['data']['ltp']);
            }
        }
    }
    void loadData() async{
        var data = (await getData());
        if(data == null){
            onError();
        } else{
            giveData(data,latestDateTime,ohlc);
        }
    }
}