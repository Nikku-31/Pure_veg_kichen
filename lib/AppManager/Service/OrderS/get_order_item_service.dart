import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Model/OrderM/get_order_items_model.dart';

class GetOrderItemsService {
  Future<GetOrderItemsModel?> getOrderItems(int orderId) async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://purevegkitchenindia.com/Api/get_order_items.php",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "order_id": orderId,
        }),
      );

      print("========== Get Order Items ==========");
      print("Request : ${jsonEncode({
        "order_id": orderId,
      })}");
      print("Status Code : ${response.statusCode}");
      print("Response : ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json["success"] == true) {
          return GetOrderItemsModel.fromJson(json);
        }
      }
    } catch (e) {
      print("Get Order Items Error : $e");
    }

    return null;
  }
}