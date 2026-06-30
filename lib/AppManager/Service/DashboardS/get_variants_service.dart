import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/DashboardM/get_variants_model.dart';

class GetVariantsService {
  Future<GetVariantsModel?> getVariants(int itemId) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://purevegkitchenindia.com/Api/get_variants_byId.php"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "item_id": itemId,
        }),
      );

      print("Request : ${jsonEncode({"item_id": itemId})}");
      print("Status : ${response.statusCode}");
      print("Response : ${response.body}");

      if (response.statusCode == 200) {
        return GetVariantsModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}