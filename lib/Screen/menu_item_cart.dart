import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../AppManager/Model/DashboardM/cart_item_model.dart';
import '../AppManager/Model/DashboardM/menu_item_model.dart';
import '../AppManager/ViewModel/DashboardVM/add_item_vm.dart';
import '../AppManager/ViewModel/DashboardVM/get_variants_vm.dart';
import '../AppManager/ViewModel/DashboardVM/wishlist_vm.dart';
import '../Screen/variant_Bottom_sheet.dart';
import '../core/constants/app_colors.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItemModel item;

  const MenuItemCard({
    super.key,
    required this.item,
  });
  @override
  Widget build(BuildContext context) {
    print("Item : ${item.name}");
    print("Variant Count : ${item.variants.length}");
    return Card(
      color: AppColors.background,
      margin: const EdgeInsets.only(bottom: 12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 110,
              height: 110,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: (item.image.isEmpty)
                        ? Container(
                      width: 120,
                      height: 150,
                      alignment: Alignment.center,
                      color: Colors.grey.shade200,
                      child: const Text(
                        "🍽️",
                        style: TextStyle(fontSize: 35),
                      ),
                    )
                        : Image.network(
                      "https://purevegkitchenindia.com/${item.image}",
                      width: 120,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 150,
                          alignment: Alignment.center,
                          color: Colors.grey.shade200,
                          child: const Text(
                            "🍽️",
                            style: TextStyle(fontSize: 35),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: Consumer<AddItemVM>(
                      builder: (context, cartVM, child) {
                        final index = cartVM.getItemIndex(int.parse(item.id));
                        final variantCount = item.variants.length;
                        if (index == -1) {
                          if (variantCount <= 1) {
                            return GestureDetector(
                              onTap: () {
                                final hasVariant = item.variants.isNotEmpty;
                                cartVM.addItem(
                                  CartItemModel(
                                    itemId: int.parse(item.id),
                                    itemName: item.name,
                                    variantName: hasVariant
                                        ? item.variants.first.value
                                        : item.name,
                                    variantId: hasVariant
                                        ? int.parse(item.variants.first.id)
                                        : 0,
                                    price: hasVariant
                                        ? double.parse(item.variants.first.price)
                                        : double.parse(item.price),
                                    image: item.image,
                                    quantity: 1,
                                  ),
                                );
                              },
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color:AppColors.primary,
                                    width: 1.3,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  "ADD",
                                  style: TextStyle(
                                    color:AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            );
                          }
                          return GestureDetector(
                            onTap: () async {
                              final variantVM =
                              Provider.of<GetVariantsVM>(context, listen: false);
                              await variantVM.getVariants(int.parse(item.id));
                              if (!context.mounted) return;
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => VariantBottomSheet(
                                  itemId: item.id,
                                  itemName: item.name,
                                  image: item.image,
                                  addons: item.addons,
                                ),
                              );
                            },
                            child: Container(
                              width: 60,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color:AppColors.primary,
                                  width: 1.3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "ADD",
                                    style: TextStyle(
                                      color:AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    "$variantCount options",
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color:Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  cartVM.decrease(index);
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  "${cartVM.getItemQuantity(int.parse(item.id))}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  cartVM.increase(index);
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ),

                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child:
                          Consumer<WishlistVM>(
                            builder: (context, wishlistVM, child) {

                              final isWishlisted =
                              wishlistVM.isWishlisted(item.id);

                              return Row(
                                children: [

                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  GestureDetector(

                                    onTap: () async {

                                      await wishlistVM.toggleWishlist(item);

                                    },

                                    child: Icon(

                                      isWishlisted
                                          ? Icons.favorite
                                          : Icons.favorite_border,

                                      color: Colors.red,
                                      size: 24,

                                    ),

                                  ),

                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    if (item.description.trim().isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(item.description),
                    ],

                    const SizedBox(height: 8),

                    Text(
                      "₹ ${item.price}",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}