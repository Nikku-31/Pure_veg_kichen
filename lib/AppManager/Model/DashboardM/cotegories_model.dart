class CategoriesModel {
  final bool success;
  final String message;
  final List<Category> data;

  CategoriesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: (json["data"] as List)
          .map((e) => Category.fromJson(e))
          .toList(),
    );
  }
}
class Category {
  final int id;
  final String name;
  final String icon;
  final int sortOrder;
  final int itemCount;
  final int isActive;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.sortOrder,
    required this.itemCount,
    required this.isActive,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      icon: json["icon"] ?? "",
      sortOrder: json["sort_order"] ?? 0,
      itemCount: json["item_count"] ?? 0,
      isActive: json["is_active"] ?? 0,
    );
  }
}