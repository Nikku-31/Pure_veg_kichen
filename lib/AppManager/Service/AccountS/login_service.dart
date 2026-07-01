import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Model/AccountM/login_model.dart';

class LoginService {
  static const String url =
      "https://purevegkitchenindia.com/Api/sign_up_login.php";

  Future<LoginResponseModel> login(String email) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
      }),
    );

    print("Request : ${jsonEncode({"email": email})}");
    print("Status Code : ${response.statusCode}");
    print("Response : ${response.body}");

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Something went wrong");
    }
  }
}