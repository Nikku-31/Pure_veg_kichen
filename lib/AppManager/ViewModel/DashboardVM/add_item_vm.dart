import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/DashboardM/cart_item_model.dart';
import 'dart:convert';

class AddItemVM extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  void addItem(CartItemModel item) {
    int index = _items.indexWhere(
          (e) =>
      e.itemId == item.itemId &&
          e.variantName == item.variantName,
    );

    if (index != -1) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    saveCart();
    notifyListeners();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    final int userId = prefs.getInt("userId") ?? 0;

    final data = _items.map((e) => e.toJson()).toList();

    await prefs.setString(
      "cart_items_$userId",
      jsonEncode(data),
    );
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();

    final int userId = prefs.getInt("userId") ?? 0;

    final data = prefs.getString("cart_items_$userId");

    if (data == null) return;

    final List decoded = jsonDecode(data);

    _items.clear();

    _items.addAll(
      decoded.map((e) => CartItemModel.fromJson(e)),
    );

    notifyListeners();
  }

  // Quantity Increase
  void increase(int index) {
    _items[index].quantity++;
    saveCart();
    notifyListeners();
  }

  // Quantity Decrease
  void decrease(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    saveCart();
    notifyListeners();
  }

  int getItemIndex(int itemId) {
    return _items.indexWhere((e) => e.itemId == itemId);
  }

  int getItemQuantity(int itemId) {
    final index = getItemIndex(itemId);
    if (index == -1) return 0;
    return _items[index].quantity;
  }

  // Delete Item
  void removeItem(int index) {
    _items.removeAt(index);
    saveCart();
    notifyListeners();
  }

  // Total Items
  int get totalItem {
    int total = 0;
    for (var item in _items) {
      total += item.quantity;
    }
    return total;
  }

  // Total Price
  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }


  // Clear Cart
  Future<void> clearCart({
    bool removeStorage = true}) async {
    _items.clear();

    if (removeStorage) {
      final prefs = await SharedPreferences.getInstance();

      final int userId = prefs.getInt("userId") ?? 0;

      await prefs.remove("cart_items_$userId");
    }

    notifyListeners();
  }
}