class GetVariantsModel {
  final bool success;
  final int total;
  final List<VariantData> data;

  GetVariantsModel({
    required this.success,
    required this.total,
    required this.data,
  });

  factory GetVariantsModel.fromJson(Map<String, dynamic> json) {
    return GetVariantsModel(
      success: json["success"] ?? false,
      total: json["total"] ?? 0,
      data: json["data"] == null
          ? []
          : List<VariantData>.from(
        json["data"].map((x) => VariantData.fromJson(x)),
      ),
    );
  }
}

class VariantData {
  final int id;
  final int itemId;
  final String label;
  final String value;
  final String price;
  final int isAvailable;
  final int sortOrder;

  VariantData({
    required this.id,
    required this.itemId,
    required this.label,
    required this.value,
    required this.price,
    required this.isAvailable,
    required this.sortOrder,
  });

  factory VariantData.fromJson(Map<String, dynamic> json) {
    return VariantData(
      id: json["id"] ?? 0,
      itemId: json["item_id"] ?? 0,
      label: json["label"] ?? "",
      value: json["value"] ?? "",
      price: json["price"] ?? "",
      isAvailable: json["is_available"] ?? 0,
      sortOrder: json["sort_order"] ?? 0,
    );
  }
}