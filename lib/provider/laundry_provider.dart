import 'package:flutter/material.dart';

import '../models/laundry_model.dart';
class LaundryProvider extends ChangeNotifier {
  List<LaundryModel> _laundries = [];
  List<LaundryModel> get laundries => _laundries;

  void setLaundries(List<LaundryModel> newList) {
    _laundries = newList;
    notifyListeners();
  }

  Future<List<LaundryModel>> fetchLaundries() async {
    await Future.delayed(const Duration(seconds: 2));

    List<LaundryModel> list = [
      LaundryModel(
        id: 1,
        name: "Miso Dry Cleaning",
        openTime: "08:00",
        closeTime: "20:00",
        rating: 4.8,
        distance: 2.0,
        totalOrders: 105,
        imageUrl: "https://cdn.pixabay.com/photo/2024/12/12/08/10/washing-machine-9262103_1280.jpg",
      ),
      LaundryModel(
        id: 2,
        name: "Express Laundry",
        openTime: "07:00",
        closeTime: "22:00",
        rating: 4.6,
        distance: 3.5,
        totalOrders: 88,
        imageUrl: "https://cdn.pixabay.com/photo/2024/12/12/08/10/washing-machine-9262103_1280.jpg",
      ),
      LaundryModel(
        id: 3,
        name: "Wash & Go",
        openTime: "09:00",
        closeTime: "18:00",
        rating: 4.4,
        distance: 1.2,
        totalOrders: 130,
        imageUrl: "https://cdn.pixabay.com/photo/2024/12/12/08/10/washing-machine-9262103_1280.jpg",
      ),
    ];

    setLaundries(list);
    return _laundries;
  }
}
