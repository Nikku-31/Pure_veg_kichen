import 'package:flutter/material.dart';
import '../../Model/DashboardM/cart_item_model.dart';

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

    notifyListeners();
  }

  // Quantity Increase
  void increase(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  // Quantity Decrease
  void decrease(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  // Delete Item
  void removeItem(int index) {
    _items.removeAt(index);
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
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}