import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/AccountM/edit_profile_model.dart';

class EditProfileService {
  static const String url =
      "https://purevegkitchenindia.com/Api/edit_profile.php";

  Future<EditProfileResponseModel> editProfile({
    required int id,
    required String name,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "id": id,
        "name": name,
        "phone": phone,
      }),
    );

    print("Request : ${jsonEncode({
      "id": id,
      "name": name,
      "phone": phone,
    })}");

    print("Response : ${response.body}");

    if (response.statusCode == 200) {
      return EditProfileResponseModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }
}