import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Screen/save_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AppManager/Model/LocationM/address_model.dart';
import '../AppManager/Model/OrderM/add_ons_model.dart';
import '../AppManager/Model/OrderM/my_order_model.dart';
import '../AppManager/Model/OrderM/place_order_model.dart';
import '../AppManager/ViewModel/DashboardVM/add_item_vm.dart';
import '../AppManager/ViewModel/OrderVM/add_ons_vm.dart';
import '../AppManager/ViewModel/OrderVM/my_order_vm.dart';
import '../AppManager/ViewModel/OrderVM/place_order_vm.dart';
import '../core/constants/app_colors.dart';
import 'Widget/address_provider.dart';
import 'my_order.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
class AddViewItem extends StatefulWidget {
  const AddViewItem({super.key});
  @override
  State<AddViewItem> createState() => _AddViewItemState();
}
class _AddViewItemState extends State<AddViewItem> {
  Map<int, List<AddonData>> itemAddons = {};
  AddressModel? selectedAddress;
  double get addonsTotal {
    return itemAddons.values
        .expand((e) => e)
        .fold<double>(
      0.0,
          (sum, addon) => sum + addon.price,
    );
  }
  @override
  void initState() {
    super.initState();
    loadAddresses();
    loadAddons();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartVM = context.read<AddItemVM>();
      final addonVM = context.read<AddonVM>();

      for (final item in cartVM.items) {
        addonVM.checkAddonAvailable(item.itemId);
      }
    });
  }
  Future<void> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("userId") ?? 0;

    context.read<AddressProvider>().loadAddresses(userId);
  }

  Future<void> saveAddons() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt("userId") ?? 0;

    final Map<String, dynamic> data = {};

    itemAddons.forEach((itemId, addons) {
      data[itemId.toString()] =
          addons.map((e) => e.toJson()).toList();
    });

    await prefs.setString(
      "addons_$userId",
      jsonEncode(data),
    );
  }

  Future<void> loadAddons() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt("userId") ?? 0;

    final jsonString = prefs.getString("addons_$userId");

    if (jsonString == null) return;

    final Map<String, dynamic> json =
    jsonDecode(jsonString);

    itemAddons.clear();

    json.forEach((key, value) {
      itemAddons[int.parse(key)] =
          (value as List)
              .map((e) => AddonData.fromJson(e))
              .toList();
    });

    setState(() {});
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
        title: Text("Add Item",
        style: TextStyle(
          color: AppColors.background
        ),),
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
                              child: (item.image.trim().isEmpty || item.image == "null")
                                  ? Container(
                                width: 120,
                                height: 120,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text("🍽️",
                                  style: TextStyle(fontSize: 35),
                                ),
                              )
                                  : Image.network(
                                "https://purevegkitchenindia.com/${item.image}",
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 70,
                                    height: 70,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text("🍽️",
                                      style: TextStyle(fontSize: 35),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.itemName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(item.variantName,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  Text("₹${item.price}",
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
                                Text("₹${(item.price * item.quantity).toStringAsFixed(0)}",
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
                        const SizedBox(height: 12),

                        if ((itemAddons[item.itemId] ?? []).isNotEmpty)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Add : ${itemAddons[item.itemId]!.map((e) => e.addonName).join(", ")}",
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                            Consumer<AddonVM>(
                              builder: (context, addonVM, child) {
                                if (addonVM.addonAvailable[item.itemId] != true) {
                                  return const SizedBox();
                                }

                                return Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () async {
                                      final addonVM = context.read<AddonVM>();
                                      await addonVM.getAddons(item.itemId);

                                      final oldSelection = itemAddons[item.itemId] ?? [];

                                      for (final addon in addonVM.addons) {
                                        addon.isSelected = oldSelection.any(
                                              (e) => e.addonId == addon.addonId,
                                        );
                                      }

                                      addonVM.selectedAddons = List.from(oldSelection);

                                      if (!context.mounted) return;

                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: AppColors.background,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            title: const Text("Choose Add-ons"),
                                            content: SizedBox(
                                              width: double.maxFinite,
                                              child: Consumer<AddonVM>(
                                                builder: (context, vm, child) {
                                                  if (vm.isLoading) {
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                  if (vm.addons.isEmpty) {
                                                    return const Text("No Add-ons Available");
                                                  }
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: vm.addons.length,
                                                    itemBuilder: (context, index) {
                                                      final addon = vm.addons[index];
                                                      return CheckboxListTile(
                                                        value: addon.isSelected,
                                                        activeColor: AppColors.primary,
                                                        checkColor: Colors.white,

                                                        title: Text(addon.addonName),
                                                        subtitle: Text("₹${addon.price}"),
                                                        onChanged: (_) {
                                                          vm.toggleAddon(addon);
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    itemAddons[item.itemId] = context
                                                        .read<AddonVM>()
                                                        .selectedAddons
                                                        .map((e) => AddonData(
                                                      addonId: e.addonId,
                                                      addonName: e.addonName,
                                                      price: e.price,
                                                      isSelected: true,
                                                    ))
                                                        .toList();
                                                  });
                                                  await saveAddons();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Done",
                                                style: TextStyle(
                                                  color: AppColors.primary
                                                ),),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit_note,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    label: const Text(
                                      "Add-ons",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
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
                        Text("₹${(cartVM.totalPrice + addonsTotal).toStringAsFixed(0)}")
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
                    if (itemAddons.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Add-ons"),
                          Text("₹${addonsTotal.toStringAsFixed(0)}"),
                        ],
                      ),

                    if (itemAddons.isNotEmpty)
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
                        Text(
                          "₹${(cartVM.totalPrice + addonsTotal).toStringAsFixed(0)}",
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
                  if (provider.addresses.isNotEmpty) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SaveAddress(
                                address: "",
                                latitude: 0.0,
                                longitude: 0.0,
                                isFromAddViewItem: true,
                              ),
                            ),
                          );
                          if (!mounted) return;
                          await loadAddresses();
                          setState(() {});
                          setState(() {});
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text("Save Address"),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Consumer<AddressProvider>(
                builder: (_, provider, __) {
                  if (provider.addresses.isEmpty) {
                    return const SizedBox();
                  }
                  return SizedBox(
                    height: 90,
                    child: DropdownButtonFormField<AddressModel>(
                      value: selectedAddress,
                      hint: const Text("Choose Address"),
                    
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black, ),
                        ),
                      ),
                    
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
                    ),
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
                    if (itemAddons.isNotEmpty) {
                      message += "\n🧀 Add-ons\n";

                      itemAddons.forEach((itemId, addons) {
                        for (var addon in addons) {
                          message += "${addon.addonName} - ₹${addon.price}\n";
                        }
                      });

                      message += "\n";
                    }
                    message +=
                        message +=
                    "💰 Total : ₹${(cartVM.totalPrice + addonsTotal).toStringAsFixed(0)}";
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