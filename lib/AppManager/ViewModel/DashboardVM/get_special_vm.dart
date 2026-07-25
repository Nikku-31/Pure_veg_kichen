import 'package:flutter/material.dart';
import '../../Model/DashboardM/get_special_model.dart';
import '../../Service/DashboardS/get_special_service.dart';

class GetSpecialVM extends ChangeNotifier {
  final GetSpecialService _service = GetSpecialService();

  bool isLoading = false;

  List<GetSpecialModel> specials = [];

  Future<void> fetchSpecialItems() async {
    isLoading = true;
    notifyListeners();

    specials = await _service.fetchSpecialItems();

    isLoading = false;
    notifyListeners();
  }
}