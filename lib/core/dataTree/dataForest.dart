class dataForest{
    final interval;
    final DataNode trees;
    final List<TimeFrame> list;
    IndicatorForest(this.interval,this.list,this.trees);
    DateTime edgedDateTime(datetime){
        return datetime.subtract(Duration(
            minutes:datetime.minute % interval,
            milliseconds: datetime.millisecond,
            microseconds: datetime.microsecond,
            seconds: datetime.second));
    }
    bool update(Map<String,dynamic> map){
        var current = edgedDateTime(map['dateTime']);
        if(list.last.dateTime == current){
            trees[0].updateCurrent(map['data']['ltp']);
            return false;
        }else{
            list.add(current);
            trees[0].addNew(map['data']['ltp']);
            return true;
        };
    }
}