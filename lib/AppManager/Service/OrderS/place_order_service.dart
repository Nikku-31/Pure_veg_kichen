import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/OrderM/place_order_model.dart';
class PlaceOrderService {
  Future<PlaceOrderResponse> placeOrder(
      PlaceOrderRequest request) async {

    final response = await http.post(
      Uri.parse("https://purevegkitchenindia.com/Api/place_order.php"),
      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode(request.toJson()),
    );

    print(request.toJson());
    print(response.body);
    print("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      return PlaceOrderResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Place Order Failed");
    }
  }
}