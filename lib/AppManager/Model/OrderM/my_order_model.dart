class MyOrderModel {
  final List<MyOrderItem> items;
  final double totalAmount;
  final String orderDate;
  final String status;
  final String orderType;

  MyOrderModel({
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.orderType,
  });

  Map<String, dynamic> toJson() {
    return {
      "items": items.map((e) => e.toJson()).toList(),
      "totalAmount": totalAmount,
      "orderDate": orderDate,
      "status": status,
      "orderType": orderType,
    };
  }

  factory MyOrderModel.fromJson(Map<String, dynamic> json) {
    return MyOrderModel(
      items: (json["items"] as List)
          .map((e) => MyOrderItem.fromJson(e))
          .toList(),
      totalAmount: (json["totalAmount"] as num).toDouble(),
      orderDate: json["orderDate"] ?? "",
      status: json["status"] ?? "",
      orderType: json["orderType"] ?? "",
    );
  }
}

class MyOrderItem {
  final int itemId;
  final int variantId;
  final String itemName;
  final String variantName;
  final double price;
  final String image;
  final int quantity;

  MyOrderItem({
    required this.itemId,
    required this.variantId,
    required this.itemName,
    required this.variantName,
    required this.price,
    required this.image,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      "itemId": itemId,
      "variantId": variantId,
      "itemName": itemName,
      "variantName": variantName,
      "price": price,
      "image": image,
      "quantity": quantity,
    };
  }

  factory MyOrderItem.fromJson(Map<String, dynamic> json) {
    return MyOrderItem(
      itemId: json["itemId"] ?? 0,
      variantId: json["variantId"] ?? 0,
      itemName: json["itemName"] ?? "",
      variantName: json["variantName"] ?? "",
      price: (json["price"] as num).toDouble(),
      image: json["image"] ?? "",
      quantity: json["quantity"] ?? 1,
    );
  }
}