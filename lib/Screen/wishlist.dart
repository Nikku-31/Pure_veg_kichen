import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../AppManager/ViewModel/DashboardVM/wishlist_vm.dart';
import '../core/constants/app_colors.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
      final size = MediaQuery
          .of(context)
          .size;
      final h = size.height;
      final w = size.width;
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          title:Text(
            "Wishlist",
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.05,
            ),
          ),
        ),

        body: Consumer<WishlistVM>(
          builder: (context, wishlistVM, child) {
            final items = wishlistVM.wishlist;

            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(
                        height: h * 0.36,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              "assets/image/wishlist.png",
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              bottom: h * 0.02,
                              left: w * 0.05,
                              right: w * 0.05,
                              child: Column(
                                children: [
                                  Text(
                                    "No items in wishlist",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: w * 0.06,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    "Save your favorite food here",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: w * 0.038,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              );
            }
            return GridView.builder(
              padding: EdgeInsets.all(w * 0.03),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: w * 0.03,
                mainAxisSpacing: h * 0.015,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(w * 0.025),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 1.3,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(w * 0.02),
                                child: Image.network(
                                  height: h * 0.15,
                                  "https://purevegkitchenindia.com/${item
                                      .image}",
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return Container(
                                      color: Colors.grey.shade100,
                                      child: const Center(
                                        child: Icon(
                                          Icons.fastfood,
                                          size: 45,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(top: h * 0.008, right: w * 0.015,
                                child: GestureDetector(
                                  onTap: () async {
                                    await wishlistVM.removeFromWishlist(
                                        item.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Removed from Wishlist"),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(w * 0.01),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.8),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: w * 0.05,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery
                                .of(context)
                                .size
                                .width * 0.036,
                          ),
                        ),
                        SizedBox(height: h * 0.004),
                        Text(
                          item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: MediaQuery
                                .of(context)
                                .size
                                .width * 0.030,
                          ),
                        ),
                        Text(
                          "₹${item.price}",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery
                                .of(context)
                                .size
                                .width * 0.038,
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