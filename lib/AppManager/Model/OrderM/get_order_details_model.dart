class GetOrderDetailsModel {
  final bool success;
  final String message;
  final int userId;
  final int totalOrders;
  final List<OrderData> data;

  GetOrderDetailsModel({
    required this.success,
    required this.message,
    required this.userId,
    required this.totalOrders,
    required this.data,
  });

  factory GetOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return GetOrderDetailsModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      userId: json["user_id"] ?? 0,
      totalOrders: json["total_orders"] ?? 0,
      data: json["data"] == null
          ? []
          : List<OrderData>.from(
        json["data"].map((x) => OrderData.fromJson(x)),
      ),
    );
  }
}

class OrderData {
  final int id;
  final int userId;
  final String customerAddress;
  final String orderType;
  final String paymentMethod;
  final String totalAmount;
  final String status;
  final String orderStage;
  final String notes;
  final String createdAt;

  OrderData({
    required this.id,
    required this.userId,
    required this.customerAddress,
    required this.orderType,
    required this.paymentMethod,
    required this.totalAmount,
    required this.status,
    required this.orderStage,
    required this.notes,
    required this.createdAt,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      customerAddress: json["customer_address"] ?? "",
      orderType: json["order_type"] ?? "",
      paymentMethod: json["payment_method"] ?? "",
      totalAmount: json["total_amount"] ?? "0",
      status: json["status"] ?? "",
      orderStage: json["order_stage"] ?? "",
      notes: json["notes"] ?? "",
      createdAt: json["created_at"] ?? "",
    );
  }
}