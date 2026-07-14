class AddonResponse {
  final bool status;
  final String message;
  final List<AddonData> data;

  AddonResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddonResponse.fromJson(Map<String, dynamic> json) {
    return AddonResponse(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<AddonData>.from(
        json["data"].map((x) => AddonData.fromJson(x)),
      ),
    );
  }
}

class AddonData {
  final int addonId;
  final String addonName;
  final double price;

  /// UI ke liye
  bool isSelected;

  AddonData({
    required this.addonId,
    required this.addonName,
    required this.price,
    this.isSelected = false,
  });

  factory AddonData.fromJson(Map<String, dynamic> json) {
    return AddonData(
      addonId: json["addon_id"] ?? 0,
      addonName: json["addon_name"] ?? "",
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "addon_id": addonId,
      "addon_name": addonName,
      "price": price,
    };
  }
}