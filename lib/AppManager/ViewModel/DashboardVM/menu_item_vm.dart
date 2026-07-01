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

        // Dashboard ke liye bhi same list
        filteredMenuItems = allMenuItems;

      } else {

        // Category Wise API
        filteredMenuItems = await _service.getMenuItems(
          categoryId: categoryId,
        );

      }

    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}