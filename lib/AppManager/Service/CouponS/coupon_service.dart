import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Model/CouponM/coupon_model.dart';

class CouponService {
  static const String url =
      "https://purevegkitchenindia.com/Api/get_coupons.php";

  Future<CouponResponse> getCoupons() async {
    try {
      final response = await http.get(Uri.parse(url));

      print("Coupon API URL: $url");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return CouponResponse.fromJson(jsonData);
      } else {
        throw Exception(
            "Failed to load coupons. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Coupon API Error: $e");
    }
  }
}