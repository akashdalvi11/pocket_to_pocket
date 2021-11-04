import '../data/interfaceData.dart';
import 'interfaceNode.dart';
import 'dataSpecNode.dart';
import 'dataNode.dart';
class InterfaceSpecNode<D extends InterfaceData>{
    final List<DataSpecNode> children;
    InterfaceSpecNode(this.children);
    InterfaceNode<D> getInterfaceNode(){
        List<DataNode> dataNodes = [];
        for(var x in children) dataNodes.add(x.getDataNode<D>());
        return InterfaceNode<D>(dataNodes);
    }
}