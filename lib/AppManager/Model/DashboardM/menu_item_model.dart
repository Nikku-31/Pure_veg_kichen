class MenuItemModel {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final String price;
  final String variantType;
  final String image;
  final String isActive;
  final String isBestseller;
  final String isJain;
  final String sortOrder;
  final String createdAt;
  final List<VariantModel> variants;

  MenuItemModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.variantType,
    required this.image,
    required this.isActive,
    required this.isBestseller,
    required this.isJain,
    required this.sortOrder,
    required this.createdAt,
    required this.variants,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json["id"]?.toString() ?? "",
      categoryId: json["category_id"]?.toString() ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      price: json["price"]?.toString() ?? "",
      variantType: json["variant_type"] ?? "",
      image: json["image"] ?? "",
      isActive: json["is_active"]?.toString() ?? "",
      isBestseller: json["is_bestseller"]?.toString() ?? "",
      isJain: json["is_jain"]?.toString() ?? "",
      sortOrder: json["sort_order"]?.toString() ?? "",
      createdAt: json["created_at"] ?? "",
      variants: (json["variants"] as List<dynamic>? ?? [])
          .map((e) => VariantModel.fromJson(e))
          .toList(),
    );
  }
}

class VariantModel {
  final String id;
  final String itemId;
  final String label;
  final String value;
  final String price;
  final String isAvailable;
  final String sortOrder;

  VariantModel({
    required this.id,
    required this.itemId,
    required this.label,
    required this.value,
    required this.price,
    required this.isAvailable,
    required this.sortOrder,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json["id"]?.toString() ?? "",
      itemId: json["item_id"]?.toString() ?? "",
      label: json["label"] ?? "",
      value: json["value"] ?? "",
      price: json["price"]?.toString() ?? "",
      isAvailable: json["is_available"]?.toString() ?? "",
      sortOrder: json["sort_order"]?.toString() ?? "",
    );
  }
}