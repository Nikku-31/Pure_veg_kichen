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
        coupons = response.data;
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