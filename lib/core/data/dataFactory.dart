class DataCreator<D extends Data>{
    final Map<String,dynamic> specs;
    D create(List<D> list,double data){
        switch(D){
            case OHLC:
                return (latest as OHLC).update(data);
            case EMA:
                return EMA.create(list.cast<EMA>(),data);
            default:
                throw "wrongType";
        }
    }
    List<D> convert<P extends Data>(List<P> parentList){
        switch(T){
            case EMA:
                switch(P){
                    case OHLC:
                        return EMA.fromParent(list.cast<OHLC>());
                    default:
                        throw "wrongType";
                }
                    
            default:
                throw "wrongType";
        }
    }
}