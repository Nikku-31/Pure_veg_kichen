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

  double get totalPrice {
    double total = 0;

    for (var e in _items) {
      total += e.price * e.quantity;
    }

    return total;
  }

  int get totalItem {
    int total = 0;

    for (var e in _items) {
      total += e.quantity;
    }

    return total;
  }
}