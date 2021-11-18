enum OrderType{buy,sell}
class Order{
	final OrderType orderType;
	final DateTime dateTime;
	final double? limit;
	Order(this.orderType,this.dateTime,this.limit);
	String toString(){
		var l = limit?.toString() ?? 'no limit';
		return '$orderType $dateTime $l';
	}
}