import 'package:flutter/material.dart';

import '../../Model/OrderM/get_order_items_model.dart';
import '../../Service/OrderS/get_order_item_service.dart';

class GetOrderItemsVM extends ChangeNotifier {
  final GetOrderItemsService _service = GetOrderItemsService();

  bool isLoading = false;

  List<OrderItemData> orderItems = [];

  Future<void> getOrderItems(int orderId) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getOrderItems(orderId);

    if (response != null && response.success) {
      orderItems = response.data;
    } else {
      orderItems = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    orderItems.clear();
    notifyListeners();
  }
}