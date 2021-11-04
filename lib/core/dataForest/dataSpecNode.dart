import '../data/data.dart';
import 'dataNode.dart';
class DataSpecNode<D extends Data>{
    final Map<String,dynamic> specs;
    final List<DataSpecNode> children;
    DataSpecNode(this.specs,this.children);
    DataNode<D,P> getDataNode<P extends Data>(){
        List<DataNode> dataNodes = [];
        for(var x in children) dataNodes.add(x.getDataNode<D>());
        return DataNode<D,P>(specs,dataNodes);
    }
}