class PlaceOrderRequest {
  final int userId;
  final String orderType;
  final String paymentMethod;
  final List<OrderItem> items;

  PlaceOrderRequest({
    required this.userId,
    required this.orderType,
    required this.paymentMethod,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "order_type": orderType,
      "payment_method": paymentMethod,
      "items": items.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderItem {
  final int itemId;
  final int variantLabel;
  final int quantity;

  OrderItem({
    required this.itemId,
    required this.variantLabel,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      "item_id": itemId,
      "variant_label": variantLabel,
      "quantity": quantity,
    };
  }
}

class PlaceOrderResponse {
  final bool success;
  final int orderId;
  final double totalAmount;

  PlaceOrderResponse({
    required this.success,
    required this.orderId,
    required this.totalAmount,
  });

  factory PlaceOrderResponse.fromJson(Map<String, dynamic> json) {
    return PlaceOrderResponse(
      success: json["success"] ?? false,
      orderId: json["order_id"] ?? 0,
      totalAmount: (json["total_amount"] ?? 0).toDouble(),
    );
  }
}