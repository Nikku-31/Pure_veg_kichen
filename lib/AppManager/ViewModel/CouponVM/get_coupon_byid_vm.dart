import 'package:flutter/material.dart';

import '../../Model/CouponM/get_coupon_byid_model.dart';
import '../../Service/CouponS/get_coupon_byid_service.dart';

class GetCouponByIdVM extends ChangeNotifier {
  final GetCouponByIdService _service =
  GetCouponByIdService();

  bool isLoading = false;

  String? error;

  List<GetCouponById> coupons = [];

  Future<void> getCouponsByItemId(
      String itemId,
      ) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response =
      await _service.getCouponsByItemId(itemId);

      if (response.status) {
        for (final coupon in response.data) {
          final alreadyExists = coupons.any(
                (e) => e.couponCode == coupon.couponCode,
          );

          if (!alreadyExists) {
            coupons.add(coupon);
          }
        }
      } else {
        error = response.message;
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    coupons.clear();
    notifyListeners();
  }
}