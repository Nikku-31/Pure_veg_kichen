import 'package:flutter/material.dart';

import '../../Model/AccountM/user_profile_model.dart';
import '../../Service/AccountS/user_profile_service.dart';

class UserProfileVM extends ChangeNotifier {
  final UserProfileService _service = UserProfileService();

  bool isLoading = false;

  UserData? user;

  Future<void> getProfile(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _service.getProfile(id);

      if (response.success) {
        user = response.data;
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}