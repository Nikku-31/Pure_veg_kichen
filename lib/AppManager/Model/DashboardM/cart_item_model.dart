class CartItemModel {
  final int itemId;
  final String itemName;
  final String variantName;
  final double price;
  final String image;
  int quantity;

  CartItemModel({
    required this.itemId,
    required this.itemName,
    required this.variantName,
    required this.price,
    required this.image,
    required this.quantity,
  });
  Map<String, dynamic> toJson() {
    return {
      "itemId": itemId,
      "itemName": itemName,
      "variantName": variantName,
      "price": price,
      "image": image,
      "quantity": quantity,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      itemId: json["itemId"],
      itemName: json["itemName"],
      variantName: json["variantName"],
      price: (json["price"] as num).toDouble(),
      image: json["image"],
      quantity: json["quantity"],
    );
  }
}