import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Model/OrderM/get_order_details_model.dart';

class GetOrderDetailsService {

  Future<GetOrderDetailsModel?> getOrderDetails(int userId) async {

    try {

      final response = await http.post(
        Uri.parse(
          "https://purevegkitchenindia.com/Api/get_orderDetials_by_userId.php",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
        }),
      );

      print("========== Get Order Details ==========");
      print("Request : ${jsonEncode({
        "user_id": userId,
      })}");
      print("Status Code : ${response.statusCode}");
      print("Response : ${response.body}");

      if (response.statusCode == 200) {

        final json = jsonDecode(response.body);

        if (json["success"] == true) {
          return GetOrderDetailsModel.fromJson(json);
        }

      }

    } catch (e) {
      print("Get Order Details Error : $e");
    }

    return null;
  }
}