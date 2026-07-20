class CouponResponse {
  final bool status;
  final String message;
  final List<Coupon> data;

  CouponResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<Coupon>.from(
        json["data"].map((x) => Coupon.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data.map((e) => e.toJson()).toList(),
    };
  }
}

class Coupon {
  final String id;
  final String couponCode;
  final String couponName;
  final String description;
  final String discountType;
  final String discountValue;
  final String maxDiscount;
  final String minOrderAmount;
  final String couponType;
  final String usageLimit;
  final String usagePerUser;
  final String timesUsed;
  final String startDate;
  final String endDate;
  final String isFirstOrderOnly;
  final String isFreeShipping;
  final String isActive;
  final String priority;
  final String categoryId;
  final String categoryName;
  final String itemId;
  final List<String> itemNames;
  final String createdAt;

  Coupon({
    required this.id,
    required this.couponCode,
    required this.couponName,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.maxDiscount,
    required this.minOrderAmount,
    required this.couponType,
    required this.usageLimit,
    required this.usagePerUser,
    required this.timesUsed,
    required this.startDate,
    required this.endDate,
    required this.isFirstOrderOnly,
    required this.isFreeShipping,
    required this.isActive,
    required this.priority,
    required this.categoryId,
    required this.categoryName,
    required this.itemId,
    required this.itemNames,
    required this.createdAt,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json["id"]?.toString() ?? "",
      couponCode: json["coupon_code"]?.toString() ?? "",
      couponName: json["coupon_name"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      discountType: json["discount_type"]?.toString() ?? "",
      discountValue: json["discount_value"]?.toString() ?? "",
      maxDiscount: json["max_discount"]?.toString() ?? "",
      minOrderAmount: json["min_order_amount"]?.toString() ?? "",
      couponType: json["coupon_type"]?.toString() ?? "",
      usageLimit: json["usage_limit"]?.toString() ?? "",
      usagePerUser: json["usage_per_user"]?.toString() ?? "",
      timesUsed: json["times_used"]?.toString() ?? "",
      startDate: json["start_date"]?.toString() ?? "",
      endDate: json["end_date"]?.toString() ?? "",
      isFirstOrderOnly: json["is_first_order_only"]?.toString() ?? "",
      isFreeShipping: json["is_free_shipping"]?.toString() ?? "",
      isActive: json["is_active"]?.toString() ?? "",
      priority: json["priority"]?.toString() ?? "",
      categoryId: json["category_id"]?.toString() ?? "",
      categoryName: json["category_name"]?.toString() ?? "",
      itemId: json["item_id"]?.toString() ?? "",
      itemNames: json["item_names"] == null
          ? []
          : List<String>.from(json["item_names"]),
      createdAt: json["created_at"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "coupon_code": couponCode,
      "coupon_name": couponName,
      "description": description,
      "discount_type": discountType,
      "discount_value": discountValue,
      "max_discount": maxDiscount,
      "min_order_amount": minOrderAmount,
      "coupon_type": couponType,
      "usage_limit": usageLimit,
      "usage_per_user": usagePerUser,
      "times_used": timesUsed,
      "start_date": startDate,
      "end_date": endDate,
      "is_first_order_only": isFirstOrderOnly,
      "is_free_shipping": isFreeShipping,
      "is_active": isActive,
      "priority": priority,
      "category_id": categoryId,
      "category_name": categoryName,
      "item_id": itemId,
      "item_names": itemNames,
      "created_at": createdAt,
    };
  }
}