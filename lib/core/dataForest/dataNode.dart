import '../data/dataFactory.dart';
import '../data/data.dart';

class DataNode<D extends Data,P extends Data>{
    final Map<String,dynamic> specs;
    final List<DataNode> children;
    late List<D> list;
    DataNode(this.specs,this.children);
    fill(List<P> parentList){
        list = DataFactory<D,P>(specs).convert(parentList);
        for(var x in children){
            x.fill(list);
        }
    }
    updateCurrent(List<P> parentList){
       list.last = DataFactory<D,P>(specs).update(list.sublist(0,list.length-1),parentList);
        for(var x in children)
            x.updateCurrent(list);
    }
    addNew(List<P> parentList){
        list.add(DataFactory<D,P>(specs).update(list,parentList));
        for(var x in children)
            x.addNew(list);
    }
}