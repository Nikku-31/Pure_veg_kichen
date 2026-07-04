import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../AppManager/ViewModel/DashboardVM/wishlist_vm.dart';
import '../core/constants/app_colors.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Wishlist",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Consumer<WishlistVM>(
        builder: (context, wishlistVM, child) {

          final items = wishlistVM.wishlist;

          if (items.isEmpty) {
            return const Center(
              child: Text(
                "Wishlist is Empty",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {

              final item = items[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),

                child: Padding(
                  padding: const EdgeInsets.all(10),

                  child: Row(
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),

                        child: Image.network(
                          "https://purevegkitchenindia.com/${item.image}",
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,

                          errorBuilder: (_, __, ___) {
                            return Container(
                              width: 90,
                              height: 90,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.fastfood,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),

                            const SizedBox(height: 6),

                            if (item.description.isNotEmpty)
                              Text(
                                item.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                            const SizedBox(height: 8),

                            Text(
                              "₹ ${item.price}",
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () async {

                          await wishlistVM.removeFromWishlist(item.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Removed from Wishlist"),
                            ),
                          );
                        },

                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}