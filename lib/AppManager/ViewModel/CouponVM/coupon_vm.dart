import 'package:flutter/material.dart';

import '../../Model/CouponM/coupon_model.dart';
import '../../Service/CouponS/coupon_service.dart';

class CouponViewModel extends ChangeNotifier {
  final CouponService _couponService = CouponService();

  bool isLoading = false;
  String? errorMessage;

  List<Coupon> coupons = [];

  Future<void> fetchCoupons() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _couponService.getCoupons();

      if (response.status) {
        coupons = response.data;
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("Coupon Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void refreshCoupons() {
    fetchCoupons();
  }
}