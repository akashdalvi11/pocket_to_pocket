class DataForestCreator{
    static DataForest createDataForest(DataSpecForest dataSpecForest,List<dynamic> data){
        var ohlcInput = _createTree(dataSpecForest.ohlcInput,data[1]);
        return DataForest(dataSpecForest.interval,data[0],[ohlcInput]);
    }
    static DataNode _createTree(specRoot,data){
        DataNode root = DataNode<specRoot.getType()>(specRoot.specs);
        _addChildren(specRoot,root);
        root.fill(data);
        return root;
    }
    static _addChildren(DataSpecNode specNode,DataNode dataNode) {
        List<DataSpecNode> queue = [];
        dataNode.children.addAll(_getDataNodes(specNode.children));
        queue.addAll(specNode.children);
        for(int i=0;i<queue.length;i++){
            _addChildren(queue[i],dataNode.children[i]);
        }
    }
    static DataNode _getDataNodes(List<DataSpecNode> specNodeChildren){
        var children = <DataNode>();
        for(var dataSpecNode in formChildren){
            children.add(DataNode<dataSpecNode.getType()>(dataSpecNode.specs));
        }
    }
}