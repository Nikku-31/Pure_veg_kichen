class LoginResponseModel {
  final bool success;
  final String message;

  LoginResponseModel({
    required this.success,
    required this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }
}