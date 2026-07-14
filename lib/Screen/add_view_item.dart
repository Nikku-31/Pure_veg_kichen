import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AppManager/Model/LocationM/address_model.dart';
import '../AppManager/Model/OrderM/my_order_model.dart';
import '../AppManager/Model/OrderM/place_order_model.dart';
import '../AppManager/ViewModel/DashboardVM/add_item_vm.dart';
import '../AppManager/ViewModel/OrderVM/my_order_vm.dart';
import '../AppManager/ViewModel/OrderVM/place_order_vm.dart';
import '../core/constants/app_colors.dart';
import 'Widget/address_provider.dart';
import 'my_order.dart';
import 'package:intl/intl.dart';
class AddViewItem extends StatefulWidget {
  const AddViewItem({super.key});
  @override
  State<AddViewItem> createState() => _AddViewItemState();
}
class _AddViewItemState extends State<AddViewItem> {
  final TextEditingController cookingRequestController =
  TextEditingController();

  bool showCookingRequest = false;
  AddressModel? selectedAddress;

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("userId") ?? 0;

    context.read<AddressProvider>().loadAddresses(userId);
  }
  @override
  void dispose() {
    cookingRequestController.dispose();
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
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "https://purevegkitchenindia.com/${item.image}",
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
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
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.add,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                label: const Text(
                                  "Add Items",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    showCookingRequest = !showCookingRequest;
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit_note,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                label: const Text(
                                  "Cooking Request",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (showCookingRequest) ...[
                          const SizedBox(height: 12),

                          TextField(
                            controller: cookingRequestController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Type cooking requests",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          // const SizedBox(height: 8),
                          //
                          // Text(
                          //   "This restaurant usually does not accept special requests, and refund in this regard will not be possible.",
                          //   style: TextStyle(
                          //     color: Colors.grey.shade600,
                          //     fontSize: 12,
                          //   ),
                          // ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
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
                        const Text("Bill Details",
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
                        Text("FREE",
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
                        const Text("Total Pay",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text("₹${cartVM.totalPrice}",
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
              const SizedBox(height: 20),

              Consumer<AddressProvider>(
                builder: (_, provider, __) {

                  if (provider.addresses.isEmpty) {
                    return const SizedBox();
                  }

                  return DropdownButtonFormField<AddressModel>(
                    value: selectedAddress,
                    hint: const Text("Choose Address"),
                    items: provider.addresses.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(
                          "${e.type} - ${e.address}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAddress = value;
                      });
                    },
                  );
                },
              ),
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

                  final addressProvider = context.read<AddressProvider>();

                  if (addressProvider.addresses.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please save address first"),
                      ),
                    );
                    return;
                  }
                  if (selectedAddress == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select address"),
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
                    customerAddress: selectedAddress!.address,
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

                    message +=
                    "📍 Address:\n"
                        "${selectedAddress!.address}\n"
                        "${selectedAddress!.addressDetails}\n"
                        "${selectedAddress!.receiverName} - ${selectedAddress!.receiverPhone}\n\n";

                    for (var item in cartVM.items) {
                      message +=
                      "🍽 ${item.itemName}\n"
                          "Variant : ${item.variantName}\n"
                          "Qty : ${item.quantity}\n"
                          "Price : ₹${(item.price * item.quantity).toStringAsFixed(0)}\n\n";
                    }
                    if (cookingRequestController.text.trim().isNotEmpty) {
                      message +=
                      "🍳 Cooking Request:\n${cookingRequestController.text.trim()}\n\n";
                    }
                    message +=
                    "💰 Total : ₹${cartVM.totalPrice.toStringAsFixed(0)}";
                    const phone = "919696660579";
                    final Uri url = Uri.parse(
                      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",

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
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
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

                            address: selectedAddress!.address,

                            totalAmount: cartVM.totalPrice,
                            orderDate: DateFormat(
                              "dd MMM yyyy, hh:mm a",
                            ).format(DateTime.now()),
                            status: "Order Sent on WhatsApp",
                          )
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
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Order Failed"),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.chat,
                  color: Colors.white,
                ),
                label: const Text("Order on WhatsApp",
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