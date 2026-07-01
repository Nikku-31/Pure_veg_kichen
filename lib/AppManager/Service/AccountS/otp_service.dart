import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/AccountM/otp_model.dart';

class OtpService {
  static const String url =
      "https://purevegkitchenindia.com/Api/Verify_otp.php";

  Future<OtpResponseModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "otp": otp,
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      return OtpResponseModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }
}