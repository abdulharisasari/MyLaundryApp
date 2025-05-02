import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;

  void setUserModel(UserModel? userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  Future<UserModel?> getMe(BuildContext context) async {
    _userModel ??= UserModel(
      id: 101,
      fullName: "Abdul Haris A",
      email: "Haris@example.com",
      userName: "haris",
      phone: "+62 812-3456-7890",
      password: "dummyPassword@123",
      imageUrl: "https://i.pravatar.cc/150?img=3",
      languageSelection: 2,
    );
    debugPrint("User profile loaded: ${_userModel?.toJson()}");
    return _userModel;
  }
}
