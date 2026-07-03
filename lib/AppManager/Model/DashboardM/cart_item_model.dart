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
}