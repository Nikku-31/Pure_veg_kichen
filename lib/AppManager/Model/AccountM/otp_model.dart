class UserModel {
  final int id;
  final String email;
  final String name;
  final String phone;
  final int isValid;


  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.isValid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? 0,
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      isValid: json["is_valid"] ?? 0,
    );
  }
}

class OtpResponseModel {
  final bool success;
  final String message;
  final UserModel? user;

  OtpResponseModel({
    required this.success,
    required this.message,
    this.user,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      user: json["user"] != null
          ? UserModel.fromJson(json["user"])
          : null,
    );
  }
}