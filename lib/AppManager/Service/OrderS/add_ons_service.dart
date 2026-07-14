import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/OrderM/add_ons_model.dart';
class AddonService {
  Future<List<AddonData>> getAddons(int itemId) async {
    final response = await http.post(
      Uri.parse(
        "https://purevegkitchenindia.com/Api/get_addmos_by_itemId.php",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "items_id": itemId,
      }),
    );

    print("===== GET ADDONS API =====");
    print("Request : ${jsonEncode({"items_id": itemId})}");
    print("Status Code : ${response.statusCode}");
    print("Response : ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final addonResponse = AddonResponse.fromJson(json);

      if (addonResponse.status) {
        return addonResponse.data;
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load addons");
    }
  }
}