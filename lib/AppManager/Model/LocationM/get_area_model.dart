class GetAreaModel {
  final bool success;
  final AreaData? data;

  GetAreaModel({
    required this.success,
    this.data,
  });

  factory GetAreaModel.fromJson(Map<String, dynamic> json) {
    return GetAreaModel(
      success: json["success"] ?? false,
      data: json["data"] != null
          ? AreaData.fromJson(json["data"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data?.toJson(),
    };
  }
}

class AreaData {
  final String pincode;
  final String area;
  final String district;
  final String state;
  final String country;

  AreaData({
    required this.pincode,
    required this.area,
    required this.district,
    required this.state,
    required this.country,
  });

  factory AreaData.fromJson(Map<String, dynamic> json) {
    return AreaData(
      pincode: json["pincode"] ?? "",
      area: json["area"] ?? "",
      district: json["district"] ?? "",
      state: json["state"] ?? "",
      country: json["country"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pincode": pincode,
      "area": area,
      "district": district,
      "state": state,
      "country": country,
    };
  }
}