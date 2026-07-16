class GetOrderItemsModel {
  final bool success;
  final List<OrderItemData> data;

  GetOrderItemsModel({
    required this.success,
    required this.data,
  });

  factory GetOrderItemsModel.fromJson(Map<String, dynamic> json) {
    return GetOrderItemsModel(
      success: json["success"] ?? false,
      data: json["data"] == null
          ? []
          : List<OrderItemData>.from(
        json["data"].map((x) => OrderItemData.fromJson(x)),
      ),
    );
  }
}

class OrderItemData {
  final int itemId;
  final String itemName;
  final String image;
  final String? variantName;
  final String price;
  final int quantity;
  final String subtotal;

  OrderItemData({
    required this.itemId,
    required this.itemName,
    required this.image,
    required this.variantName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });
  factory OrderItemData.fromJson(Map<String, dynamic> json) {
    return OrderItemData(
      itemId: json["item_id"] ?? 0,
      itemName: json["item_name"] ?? "",   
      image: json["image"] ?? "",
      variantName: json["variant_name"],
      price: json["price"] ?? "0",
      quantity: json["quantity"] ?? 0,
      subtotal: json["subtotal"] ?? "0",
    );
  }
}