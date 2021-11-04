import 'interfaceNode.dart';
class DataForest{
    final List<DateTime> list;
    final List<InterfaceNode> trees;
    DataForest(this.list,this.trees);
    bool update(Map<String,dynamic> map){
        if(map['dateTime'] == list.last){
            trees[0].updateCurrent(map['ltp']);
            return false;
        }else{
            list.add(map['dateTime']);
            trees[0].addNew(map['ltp']);
            return true;
        }
    }
}