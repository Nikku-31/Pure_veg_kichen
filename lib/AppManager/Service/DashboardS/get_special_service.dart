import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/DashboardM/get_special_model.dart';

class GetSpecialService {
  Future<List<GetSpecialModel>> fetchSpecialItems() async {
    final url = Uri.parse(
      "https://purevegkitchenindia.com/Api/get_special_item.php",
    );

    print("GET : $url");

    final response = await http.get(url);

    print("Status : ${response.statusCode}");
    print("Response : ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData["status"] == true) {
        return (jsonData["data"] as List)
            .map((e) => GetSpecialModel.fromJson(e))
            .toList();
      }
    }

    return [];
  }
}