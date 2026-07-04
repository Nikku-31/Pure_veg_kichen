import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/LocationM/get_area_model.dart';

class GetAreaService {
  static const String url =
      "https://purevegkitchenindia.com/Api/get_area_by_pincode.php";

  Future<GetAreaModel> getAreaByPincode(String pincode) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "pincode": pincode,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return GetAreaModel.fromJson(json);
      } else {
        throw Exception(
          "Failed to load area. Status Code : ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Get Area API Error : $e");
    }
  }
}