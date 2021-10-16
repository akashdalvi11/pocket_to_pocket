class DataSpecNode<D extends Data>{
    final Map<String,dynamic> specs;
    final List<DataSpecNode> children = [];
    D getType()=>D;
}