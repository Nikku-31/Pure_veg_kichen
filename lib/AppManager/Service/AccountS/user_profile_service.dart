import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/AccountM/user_profile_model.dart';

class UserProfileService {
  static const String url =
      "https://purevegkitchenindia.com/Api/get_user_byId.php";

  Future<UserProfileModel> getProfile(int id) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "id": id,
      }),
    );

    print("Profile Request : ${response.request?.url}");
    print("Profile Response : ${response.body}");

    if (response.statusCode == 200) {
      return UserProfileModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load profile");
    }
  }
}