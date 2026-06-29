import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/DashboardM/cotegories_model.dart';

class CategoriesService {
  static const String url =
      "https://purevegkitchenindia.com/Api/categories_Api.php";

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final model = CategoriesModel.fromJson(jsonData);

      return model.data;
    } else {
      throw Exception("Failed to load Categories");
    }
  }
}