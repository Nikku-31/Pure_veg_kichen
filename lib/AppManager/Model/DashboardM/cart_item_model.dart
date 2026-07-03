class CartItemModel {
  final int itemId;
  final String itemName;
  final String variantName;
  final double price;
  int quantity;

  CartItemModel({
    required this.itemId,
    required this.itemName,
    required this.variantName,
    required this.price,
    required this.quantity,
  });
}