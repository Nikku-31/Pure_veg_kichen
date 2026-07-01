import 'package:flutter/material.dart';

import '../../Model/AccountM/otp_model.dart';
import '../../Service/AccountS/otp_service.dart';

class OtpVM extends ChangeNotifier {
  final OtpService _service = OtpService();

  bool isLoading = false;

  OtpResponseModel? responseModel;

  Future<bool> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      responseModel = await _service.verifyOtp(
        email: email,
        otp: otp,
      );

      isLoading = false;
      notifyListeners();

      return responseModel!.success;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}