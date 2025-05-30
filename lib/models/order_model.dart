class OrderModel {
  int? id;
  int? qty;
  int? laundryId; 
  int? price; 
  String? serviceName; 
  String? serviceType; 
  String? address; 
  String? orderTime; 
  String? estimatedFinish; 
  String? imageUrl;
  


  OrderModel({this.id, this.serviceName, this.serviceType, this.address, this.orderTime, this.estimatedFinish, this.price, this.qty, this.laundryId, this.imageUrl});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      serviceName: json['service_name'],
      serviceType: json['service_type'],
      address: json['address'],
      orderTime: json['order_time'],
      estimatedFinish: json['estimated_finish'],
      price: json['price'],
      qty: json['qty'],
      laundryId: json['laundry_id'],
      imageUrl: json['image_url']
    );
  }

  static List<OrderModel> fromList(List<dynamic> list){
    return list.map((e) => OrderModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'service_name': serviceName,
        'service_type': serviceType,
        'address': address,
        'order_time': orderTime,
        'estimated_finish': estimatedFinish,
        'price': price,
        'qty': qty,
        'laundry_id': laundryId,
        'image_url': imageUrl
      };
}
