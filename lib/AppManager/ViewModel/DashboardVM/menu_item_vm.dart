import 'package:flutter/material.dart';

import '../../Model/DashboardM/menu_item_model.dart';
import '../../Service/DashboardS/menu_item_service.dart';

class MenuItemVM extends ChangeNotifier {
  final MenuItemService _service = MenuItemService();

  bool isLoading = false;

  List<MenuItemModel> menuItems = [];

  Future<void> fetchMenuItems() async {
    isLoading = true;
    notifyListeners();

    try {
      menuItems = await _service.getMenuItems();
      print(menuItems.length);
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}