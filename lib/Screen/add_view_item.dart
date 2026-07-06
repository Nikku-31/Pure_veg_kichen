import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AppManager/Model/OrderM/my_order_model.dart';
import '../AppManager/Model/OrderM/place_order_model.dart';
import '../AppManager/ViewModel/DashboardVM/add_item_vm.dart';
import '../AppManager/ViewModel/OrderVM/my_order_vm.dart';
import '../AppManager/ViewModel/OrderVM/place_order_vm.dart';
import '../core/constants/app_colors.dart';
import 'my_order.dart';
import 'package:intl/intl.dart';
class AddViewItem extends StatefulWidget {
  const AddViewItem({super.key});

  @override
  State<AddViewItem> createState() => _AddViewItemState();
}

class _AddViewItemState extends State<AddViewItem> {
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }
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

              // Address
              const SizedBox(height: 20),

              TextField(
                controller: addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Delivery Address",
                  hintText: "Enter your complete address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.location_on),
                ),
              ),

              const SizedBox(height: 20),
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
                  if (addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter delivery address"),
                      ),
                    );
                    return;
                  }

                  final prefs = await SharedPreferences.getInstance();
                  final int userId = prefs.getInt("userId") ?? 0;
                  final cartVM = context.read<AddItemVM>();
                  final orderVM = context.read<PlaceOrderVM>();

                  final request = PlaceOrderRequest(
                    userId: userId,
                    customerAddress: addressController.text.trim(),
                    orderType: "delivery",
                    paymentMethod: "cod",
                    items: cartVM.items.map((e) {
                      return OrderItem(
                        itemId: e.itemId,
                        variantLabel: e.variantId,
                        quantity: e.quantity,
                      );
                    }).toList(),
                  );
                  bool success = await orderVM.placeOrder(request);

                  if (success) {

                    String message = "🛒 *New Order*\n\n";

                    message += "📍 Address:\n${addressController.text.trim()}\n\n";

                    for (var item in cartVM.items) {
                      message +=
                      "🍽 ${item.itemName}\n"
                          "Variant : ${item.variantName}\n"
                          "Qty : ${item.quantity}\n"
                          "Price : ₹${(item.price * item.quantity).toStringAsFixed(0)}\n\n";
                    }

                    message +=
                    "💰 Total : ₹${cartVM.totalPrice.toStringAsFixed(0)}";

                    const phone = "919696660579";

                    final Uri url = Uri.parse(
                      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",

                    );

                    await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );

                    final bool? isSent = await showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AlertDialog(
                        backgroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: const Text("Confirm"),
                        content: const Text(
                          "Have you sent the order on WhatsApp?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("No",
                            style: TextStyle(
                              color: Colors.black
                            ),),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Yes"),
                          ),
                        ],
                      ),
                    );

                    if (isSent == true) {

                      final myOrderVM = context.read<MyOrderVM>();

                      await myOrderVM.saveOrder(
                        userId,
                        MyOrderModel(
                            orderType: "Regular Order",
                          items: cartVM.items.map((e) {
                            return MyOrderItem(
                              itemId: e.itemId,
                              variantId: e.variantId,
                              itemName: e.itemName,
                              variantName: e.variantName,
                              price: e.price,
                              image: e.image,
                              quantity: e.quantity,
                            );
                          }).toList(),
                          address: addressController.text.trim(),
                          totalAmount: cartVM.totalPrice,
                          orderDate: DateFormat(
                            "dd MMM yyyy, hh:mm a",
                          ).format(DateTime.now()),
                          status: "Order Sent on WhatsApp",
                        ),
                      );

                      await cartVM.clearCart();

                      if (!context.mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyOrderPage(),
                        ),
                      );
                    }
                  } else {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Order Failed"),
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