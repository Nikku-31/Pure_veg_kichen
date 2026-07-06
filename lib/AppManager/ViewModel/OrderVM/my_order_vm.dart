import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/OrderM/my_order_model.dart';

class MyOrderVM extends ChangeNotifier {
  final List<MyOrderModel> _orders = [];

  List<MyOrderModel> get orders => _orders;

  /// Save New Order
  Future<void> saveOrder(int userId, MyOrderModel order) async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString("my_orders_$userId");

    _orders.clear();

    if (data != null && data.isNotEmpty) {
      final List decoded = jsonDecode(data);

      _orders.addAll(
        decoded.map((e) => MyOrderModel.fromJson(e)).toList(),
      );
    }

    _orders.insert(0, order);

    await prefs.setString(
      "my_orders_$userId",
      jsonEncode(
        _orders.map((e) => e.toJson()).toList(),
      ),
    );

    notifyListeners();
  }
  /// Load Orders
  Future<void> loadOrders(int userId) async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString("my_orders_$userId");

    _orders.clear();

    if (data == null || data.isEmpty) {
      notifyListeners();
      return;
    }

    final List decoded = jsonDecode(data);

    _orders.clear();

    _orders.addAll(
      decoded.map((e) => MyOrderModel.fromJson(e)).toList(),
    );

    notifyListeners();
  }

  /// Delete Order
  Future<void> deleteOrder(int userId, int index) async {
    _orders.removeAt(index);

    final prefs = await SharedPreferences.getInstance();

    final data = _orders.map((e) => e.toJson()).toList();

    await prefs.setString(
      "my_orders_$userId",
      jsonEncode(data),
    );
    notifyListeners();
  }

  /// Clear All Orders
  Future<void> clearOrders(int userId) async {
    _orders.clear();

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("my_orders_$userId");

    notifyListeners();
  }

  /// Get Single Order
  MyOrderModel getOrder(int index) {
    return _orders[index];
  }

  /// Total Orders
  int get totalOrders => _orders.length;
}