import 'package:flutter/material.dart';

import '../../Model/OrderM/get_order_details_model.dart';
import '../../Service/OrderS/get_order_details_service.dart';

class GetOrderDetailsVM extends ChangeNotifier {
  final GetOrderDetailsService _service = GetOrderDetailsService();

  bool isLoading = false;

  GetOrderDetailsModel? orderDetailsModel;

  List<OrderData> orderList = [];

  Future<void> getOrders(int userId) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getOrderDetails(userId);

    if (response != null && response.success) {
      orderDetailsModel = response;
      orderList = response.data;
    } else {
      orderDetailsModel = null;
      orderList = [];
    }

    print("User Id : $userId");
    print("Total Orders : ${orderList.length}");

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshOrders(int userId) async {
    await getOrders(userId);
  }

  OrderData getOrder(int index) {
    return orderList[index];
  }

  int get totalOrders => orderList.length;
}