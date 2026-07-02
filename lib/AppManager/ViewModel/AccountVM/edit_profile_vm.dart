import 'package:flutter/material.dart';

import '../../Model/AccountM/edit_profile_model.dart';
import '../../Service/AccountS/edit_profile_service.dart';

class EditProfileVM extends ChangeNotifier {
  final EditProfileService _service = EditProfileService();

  bool isLoading = false;

  EditProfileResponseModel? responseModel;

  Future<bool> updateProfile({
    required int id,
    required String name,
    required String phone,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      responseModel = await _service.editProfile(
        id: id,
        name: name,
        phone: phone,
      );

      isLoading = false;
      notifyListeners();

      return responseModel!.success;
    } catch (e) {
      isLoading = false;
      notifyListeners();

      print(e);

      return false;
    }
  }
}