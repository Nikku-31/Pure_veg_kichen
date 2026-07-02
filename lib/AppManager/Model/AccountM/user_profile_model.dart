class UserProfileModel {
  final bool success;
  final String message;
  final UserData? data;

  UserProfileModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null
          ? UserData.fromJson(json["data"])
          : null,
    );
  }
}

class UserData {
  final int id;
  final String email;
  final String name;
  final String phone;

  UserData({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: int.tryParse(json["id"].toString()) ?? 0,
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
    );
  }
}