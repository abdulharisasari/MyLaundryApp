import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  void setOrders(List<OrderModel> newOrders) {
    _orders = newOrders;
    notifyListeners();
  }

  Future<List<OrderModel>> fetchOrders() async {
    await Future.delayed(const Duration(seconds: 2));

    List<OrderModel> list = [
      OrderModel(id: 1, serviceName: "Cuci Kering", serviceType: "Reguler", address: "Jalan Melati No. 21", orderTime: "2025-05-10 09:30", estimatedFinish: "2025-05-11 09:30", price: 15000, qty: 2, laundryId: 1, imageUrl: "https://cdn.pixabay.com/photo/2024/12/12/08/10/washing-machine-9262103_1280.jpg"),
      OrderModel(id: 2, serviceName: "Setrika", serviceType: "Express", address: "Jalan Kenanga No. 15", orderTime: "2025-05-09 16:00", estimatedFinish: "2025-05-10 08:00", price: 10000, qty: 3, laundryId: 2, imageUrl: "https://cdn.pixabay.com/photo/2024/12/12/08/10/washing-machine-9262103_1280.jpg"),
      OrderModel(id: 3, serviceName: "Cuci + Setrika", serviceType: "Reguler", address: "Jalan Dahlia No. 8", orderTime: "2025-05-08 14:15", estimatedFinish: "2025-05-09 14:15", price: 25000, qty: 1, laundryId: 3, imageUrl: "https://cdn.pixabay.com/photo/2024/12/12/08/10/washing-machine-9262103_1280.jpg"),
      OrderModel(id: 4, serviceName: "Dry Clean", serviceType: "Premium", address: "Jalan Anggrek No. 4", orderTime: "2025-05-07 10:00", estimatedFinish: "2025-05-08 10:00", price: 35000, qty: 1, laundryId: 1, imageUrl: "https://cdn.pixabay.com/photo/2024/12/12/08/10/washing-machine-9262103_1280.jpg"),
      OrderModel(id: 5, serviceName: "Karpet", serviceType: "Reguler", address: "Jalan Teratai No. 11", orderTime: "2025-05-06 13:45", estimatedFinish: "2025-05-07 13:45", price: 50000, qty: 1, laundryId: 2, imageUrl: "https://cdn.pixabay.com/photo/2024/12/12/08/10/washing-machine-9262103_1280.jpg"),
      OrderModel(id: 6, serviceName: "Sprei & Selimut", serviceType: "Express", address: "Jalan Mawar No. 5", orderTime: "2025-05-05 17:00", estimatedFinish: "2025-05-06 10:00", price: 45000, qty: 2, laundryId: 3, imageUrl: "https://cdn.pixabay.com/photo/2024/12/12/08/10/washing-machine-9262103_1280.jpg"),
      OrderModel(id: 7, serviceName: "Cuci Sepatu", serviceType: "Premium", address: "Jalan Flamboyan No. 17", orderTime: "2025-05-04 08:20", estimatedFinish: "2025-05-05 08:20", price: 30000, qty: 1, laundryId: 1, imageUrl: "https://cdn.pixabay.com/photo/2024/12/12/08/10/washing-machine-9262103_1280.jpg"),
      OrderModel(id: 8, serviceName: "Bantal & Guling", serviceType: "Reguler", address: "Jalan Kemuning No. 9", orderTime: "2025-05-03 15:10", estimatedFinish: "2025-05-04 15:10", price: 40000, qty: 2, laundryId: 2, imageUrl: "https://cdn.pixabay.com/photo/2024/12/12/08/10/washing-machine-9262103_1280.jpg"),
    ];

    setOrders(list);
    return _orders;
  }
}
