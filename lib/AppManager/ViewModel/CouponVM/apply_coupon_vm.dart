import 'package:flutter/material.dart';

class ApplyCouponVM extends ChangeNotifier {
  bool isCouponApplied = false;

  String appliedCouponCode = "";
  String appliedCouponName = "";

  double discountAmount = 0;

  void applyCoupon({
    required String couponCode,
    required String couponName,
    required double discount,
  }) {
    appliedCouponCode = couponCode;
    appliedCouponName = couponName;
    discountAmount = discount;
    isCouponApplied = true;

    notifyListeners();
  }

  void removeCoupon() {
    appliedCouponCode = "";
    appliedCouponName = "";
    discountAmount = 0;
    isCouponApplied = false;

    notifyListeners();
  }

  double get couponDiscount => discountAmount;
}