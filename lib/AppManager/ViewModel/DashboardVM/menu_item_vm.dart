import 'package:flutter/material.dart';

import '../../Model/DashboardM/menu_item_model.dart';
import '../../Service/DashboardS/menu_item_service.dart';

class MenuItemVM extends ChangeNotifier {
  final MenuItemService _service = MenuItemService();

  bool isLoading = false;

  List<MenuItemModel> menuItems = [];

// All items
  List<MenuItemModel> allMenuItems = [];

// Dashboard ke liye
  List<MenuItemModel> filteredMenuItems = [];

  Future<void> fetchMenuItems({String? categoryId}) async {

    isLoading = true;
    notifyListeners();

    try {

      if (categoryId == null || categoryId.isEmpty) {

        // All Items API
        allMenuItems = await _service.getMenuItems();

        // Search ke liye
        menuItems = List.from(allMenuItems);

        // Dashboard ke liye
        filteredMenuItems = List.from(allMenuItems);

      } else {

        // Category Wise API
        menuItems = await _service.getMenuItems(
          categoryId: categoryId,
        );

        filteredMenuItems = List.from(menuItems);

      }

    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  void searchMenuItems(String keyword) {
    if (keyword.trim().isEmpty) {
      filteredMenuItems = List.from(menuItems);
    } else {
      filteredMenuItems = menuItems.where((item) {
        return item.name
            .toLowerCase()
            .contains(keyword.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }
}