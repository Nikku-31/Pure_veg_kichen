import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Model/CouponM/get_coupon_byid_model.dart';

class GetCouponByIdService {
  static const String url =
      "https://purevegkitchenindia.com/Api/get_coupons_by_items_id.php";

  Future<GetCouponByIdResponse> getCouponsByItemId(
      String itemId,
      ) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type":"application/json",
        },
        body: jsonEncode({
          "item_id": itemId,
        }),
      );
      print("Coupon By Item API : $url");
      print("Request : item_id=$itemId");
      print("Status Code : ${response.statusCode}");
      print("Response : ${response.body}");

      if (response.statusCode == 200) {
        return GetCouponByIdResponse.fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw Exception("Failed");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}