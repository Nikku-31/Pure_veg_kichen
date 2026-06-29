import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/DashboardM/menu_item_model.dart';

class MenuItemService {
  Future<List<MenuItemModel>> getMenuItems() async {
    final response = await http.get(
      Uri.parse("https://purevegkitchenindia.com/Api/menu_items_Api.php"),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      final List list = jsonData["data"];

      return list
          .map((e) => MenuItemModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed");
    }
  }
}