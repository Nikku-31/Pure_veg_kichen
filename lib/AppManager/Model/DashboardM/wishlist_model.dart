import '../DashboardM/menu_item_model.dart';

class WishlistModel {
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

  WishlistModel({
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
  });

  factory WishlistModel.fromMenuItem(MenuItemModel item) {
    return WishlistModel(
      id: item.id,
      categoryId: item.categoryId,
      name: item.name,
      description: item.description,
      price: item.price,
      variantType: item.variantType,
      image: item.image,
      isActive: item.isActive,
      isBestseller: item.isBestseller,
      isJain: item.isJain,
      sortOrder: item.sortOrder,
      createdAt: item.createdAt,
    );
  }

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json["id"] ?? "",
      categoryId: json["categoryId"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      price: json["price"] ?? "",
      variantType: json["variantType"] ?? "",
      image: json["image"] ?? "",
      isActive: json["isActive"] ?? "",
      isBestseller: json["isBestseller"] ?? "",
      isJain: json["isJain"] ?? "",
      sortOrder: json["sortOrder"] ?? "",
      createdAt: json["createdAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "categoryId": categoryId,
      "name": name,
      "description": description,
      "price": price,
      "variantType": variantType,
      "image": image,
      "isActive": isActive,
      "isBestseller": isBestseller,
      "isJain": isJain,
      "sortOrder": sortOrder,
      "createdAt": createdAt,
    };
  }
}