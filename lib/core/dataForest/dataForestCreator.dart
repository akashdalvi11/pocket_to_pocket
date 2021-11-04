import 'dataForest.dart';
import 'dataNode.dart';
import 'dataSpecForest.dart';
import 'dataSpecNode.dart';
import '../data/data.dart';
import '../data/interfaceData/ohlc.dart';
class DataForestCreator{
    static DataForest createDataForest(DataSpecForest dataSpecForest,List<dynamic> data){
        var ohlcInterface = dataSpecForest.trees[0].getInterfaceNode();
        ohlcInterface.fill(data[1]);
        return DataForest(data[0],[ohlcInterface]);
    }
}