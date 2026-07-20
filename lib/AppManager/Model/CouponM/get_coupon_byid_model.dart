class GetCouponByIdResponse {
  final bool status;
  final String message;
  final List<GetCouponById> data;

  GetCouponByIdResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetCouponByIdResponse.fromJson(Map<String, dynamic> json) {
    return GetCouponByIdResponse(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<GetCouponById>.from(
        json["data"].map((x) => GetCouponById.fromJson(x)),
      ),
    );
  }
}

class GetCouponById {
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
  final String categoryName;

  GetCouponById({
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
    required this.categoryName,
  });

  factory GetCouponById.fromJson(Map<String, dynamic> json) {
    return GetCouponById(
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
      categoryName: json["category_name"]?.toString() ?? "",
    );
  }
}