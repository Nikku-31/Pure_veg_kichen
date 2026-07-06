import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AppManager/ViewModel/DashboardVM/add_item_vm.dart';
import '../core/constants/app_colors.dart';

class AddViewItem extends StatelessWidget {
  const AddViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(
          color: AppColors.background
        ),
        // title: const Text("My Cart",
        // style: TextStyle(
        //   color: AppColors.background
        // ),),
      ),
      body: Consumer<AddItemVM>(
        builder: (context, cartVM, child) {
          if (cartVM.items.isEmpty) {
            return const Center(
              child: Text("No Item Added"),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [

              // Cart Items
              ...List.generate(cartVM.items.length, (index) {
                final item = cartVM.items[index];

                return Card(
                  color: Colors.grey.shade200,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "https://purevegkitchenindia.com/${item.image}",
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.fastfood),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.itemName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                item.variantName,
                                style: const TextStyle(color: Colors.grey),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "₹${item.price}",
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "₹${(item.price * item.quantity).toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                InkWell(
                                  onTap: () => cartVM.decrease(index),
                                  child: const Icon(Icons.remove_circle_outline),
                                ),

                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(item.quantity.toString()),
                                ),

                                InkWell(
                                  onTap: () => cartVM.increase(index),
                                  child: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),

              // Bill Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [

                    Row(
                      children: [
                        const Icon(Icons.receipt_long,
                            color: AppColors.primary),

                        const SizedBox(width: 10),

                        const Text(
                          "Bill Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Item Total"),
                        Text("₹${cartVM.totalPrice}")
                      ],
                    ),

                    const Divider(height: 30),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Delivery Fee"),
                        Text(
                          "FREE",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 30),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("GST & Other Charges"),
                        Text("₹0"),
                      ],
                    ),

                    const Divider(height: 30),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Pay",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "₹${cartVM.totalPrice}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          );
        },
      ),

      bottomNavigationBar: SafeArea(
        child: Consumer<AddItemVM>(
          builder: (context, cartVM, child) {
            if (cartVM.items.isEmpty) {
              return const SizedBox();
            }
        
            return Container(
              padding: const EdgeInsets.all(16),
              height: 80,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  String message = "New Order";
        
                  for (var item in cartVM.items) {
                    message +=
                    "• ${item.itemName} (${item.variantName})\n"
                        "Qty : ${item.quantity}\n"
                        "Price : ₹${(item.price * item.quantity).toStringAsFixed(0)}\n";
                  }
        
                  message += "💰 *Total :* ₹${cartVM.totalPrice.toStringAsFixed(0)}";
                  const phone = "919935592408";
                  final Uri url = Uri.parse(
                    "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
                  );
        
                  try {
                    await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Unable to open WhatsApp"),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.chat,
                  color: Colors.white,
                ),
                label: const Text(
                  "Order on WhatsApp",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}