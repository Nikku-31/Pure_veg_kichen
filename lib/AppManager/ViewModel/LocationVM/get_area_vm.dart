import 'package:flutter/material.dart';
import '../../Model/LocationM/get_area_model.dart';
import '../../Service/LocationS/get_area_service.dart';

class GetAreaVM extends ChangeNotifier {
  final GetAreaService _service = GetAreaService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  AreaData? _areaData;
  AreaData? get areaData => _areaData;

  Future<bool> getAreaByPincode(String pincode) async {
    try {
      _isLoading = true;
      _errorMessage = "";
      notifyListeners();

      final response = await _service.getAreaByPincode(pincode);

      if (response.success && response.data != null) {
        _areaData = response.data;

        _isLoading = false;
        notifyListeners();

        return true;
      } else {
        _errorMessage = "Area not found";
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();

    return false;
  }

  void clearArea() {
    _areaData = null;
    _errorMessage = "";
    notifyListeners();
  }
}