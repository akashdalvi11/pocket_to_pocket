import '../data/data.dart';
import '../data/interfaceData.dart';
import '../data/interfaceData/ohlc.dart';
import 'dataNode.dart';
class InterfaceNode<D extends InterfaceData>{
    late List<D> list;
    final List<DataNode> children;
    InterfaceNode(this.children);
    fill(List<D> list){
        this.list = list;
        for(var x in children){
            x.fill(list);
        }
    }
    updateCurrent(double data){
        dynamic updated = list.last.updated(data);
        list.last = updated;
        for(var x in children)
            x.updateCurrent(list);
    }
    addNew(double data){
        dynamic justFormed;
        if(D==OHLC) justFormed = OHLC.justFormed(data);
        list.add(justFormed);
        for(var x in children)
            x.addNew(list);
    }
    String toString(){
        var sl = list.length -2;
        var s = '${list[sl]}\n';
        for(var x in children) s+= '$x\n';
        return s;
    }
}