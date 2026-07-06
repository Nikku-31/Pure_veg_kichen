import 'package:flutter/material.dart';
import '../../Model/OrderM/place_order_model.dart';
import '../../Service/OrderS/place_order_service.dart';
class PlaceOrderVM extends ChangeNotifier {
  final PlaceOrderService _service = PlaceOrderService();

  bool isLoading = false;

  PlaceOrderResponse? orderResponse;

  Future<bool> placeOrder(PlaceOrderRequest request) async {
    isLoading = true;
    notifyListeners();

    try {
      orderResponse = await _service.placeOrder(request);

      isLoading = false;
      notifyListeners();

      return orderResponse!.success;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("Place Order Error: $e");
      return false;
    }
  }
}