class EditProfileResponseModel {
  final bool success;
  final String message;
  final EditProfileData? data;

  EditProfileResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory EditProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return EditProfileResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null
          ? EditProfileData.fromJson(json["data"])
          : null,
    );
  }
}

class EditProfileData {
  final int id;
  final String email;
  final String name;
  final String phone;
  final String createdAt;
  final String updatedAt;

  EditProfileData({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EditProfileData.fromJson(Map<String, dynamic> json) {
    return EditProfileData(
      id: int.tryParse(json["id"].toString()) ?? 0,
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }
}