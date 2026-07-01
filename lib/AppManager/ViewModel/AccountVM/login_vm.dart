import 'package:flutter/material.dart';

import '../../Model/AccountM/login_model.dart';
import '../../Service/AccountS/login_service.dart';

class LoginVM extends ChangeNotifier {
  final LoginService _service = LoginService();

  bool isLoading = false;

  LoginResponseModel? loginResponse;

  Future<bool> login(String email) async {
    try {
      isLoading = true;
      notifyListeners();

      loginResponse = await _service.login(email);

      isLoading = false;
      notifyListeners();

      return loginResponse!.success;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint(e.toString());
      return false;
    }
  }
}