class DataNode<D extends Data>{
    final Map<String,dynamic> specs;
    late List<IndicatorData> list;
    IndicatorNode(this.specs);
    fill<P extends Data>(List<P> parentList){
        list = IndicatorDataCreator<D>(specs).createList<P>(parentList);
    }
    D _create(data){
        return IndicatorDataCreator<D>(specs).create(list,data);
    }
    updateCurrent(double data){
        list.last = IndicatorDataCreator<D>(specs).create(list.subList(0,list.length-1),data);
    }
    addNew(double data){
        list.add(IndicatorDataCreator<D>(specs).create(list,data));
    }
}