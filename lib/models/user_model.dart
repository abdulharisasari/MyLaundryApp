class UserModel {
  int? id,languageSelection;
  String? fullName,userName, email, phone, password, imageUrl;

  UserModel({this.id, this.fullName, this.userName, this.email, this.phone, this.password, this.imageUrl, this.languageSelection});

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['id'],
      fullName: json['fullname'],
      userName: json['username'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      imageUrl: json['image_url'],
      languageSelection: json['languageselection'],
    );
  }

  static List<UserModel> fromList(List<dynamic> list){
    return list.map((e) => UserModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullname': fullName,
    'username': userName,
    'email': email,
    'phone': phone,
    'password': password,
    'image_url': imageUrl,
    'languageselection': languageSelection,
  };
}