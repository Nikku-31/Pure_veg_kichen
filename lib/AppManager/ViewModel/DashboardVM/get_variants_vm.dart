import 'package:flutter/material.dart';
import '../../Model/DashboardM/get_variants_model.dart';
import '../../Service/DashboardS/get_variants_service.dart';
class GetVariantsVM extends ChangeNotifier {
  final GetVariantsService _service = GetVariantsService();

  bool isLoading = false;

  List<VariantData> variants = [];

  Future<void> getVariants(int itemId) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getVariants(itemId);

    if (response != null && response.success) {
      variants = response.data;
    } else {
      variants = [];
    }

    print("Item Id : $itemId");
    print("Variant Count : ${variants.length}");

    isLoading = false;
    notifyListeners();
  }
}