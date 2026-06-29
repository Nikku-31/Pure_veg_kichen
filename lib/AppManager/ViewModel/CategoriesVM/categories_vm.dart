import 'package:flutter/material.dart';
import '../../Model/CategoriesM/cotegories_model.dart';
import '../../Service/CategoriesS/categories_service.dart';

class CategoriesVM extends ChangeNotifier {
  final CategoriesService _service = CategoriesService();

  bool isLoading = false;

  List<Category> categories = [];

  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      categories = await _service.getCategories();
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}