class LaundryModel {
  int? id;
  String? name;
  String? openTime;
  String? closeTime;
  double? rating;
  double? distance;
  int? totalOrders;
  String? imageUrl; // ← Tambahan

  LaundryModel({
    this.id,
    this.name,
    this.openTime,
    this.closeTime,
    this.rating,
    this.distance,
    this.totalOrders,
    this.imageUrl, // ← Tambahan
  });

  factory LaundryModel.fromJson(Map<String, dynamic> json) {
    return LaundryModel(
      id: json['id'],
      name: json['name'],
      openTime: json['open_time'],
      closeTime: json['close_time'],
      rating: (json['rating'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      totalOrders: json['total_orders'],
      imageUrl: json['image_url'], // ← Tambahan
    );
  }

  static List<LaundryModel> fromList(List<dynamic> list) {
    return list.map((e) => LaundryModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'open_time': openTime,
        'close_time': closeTime,
        'rating': rating,
        'distance': distance,
        'total_orders': totalOrders,
        'image_url': imageUrl, // ← Tambahan
      };
}
