import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'package:intl/intl.dart';
import '../AppManager/Model/OrderM/my_order_model.dart';
import '../AppManager/ViewModel/OrderVM/my_order_vm.dart';
import 'my_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
class OrderPreview extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController pinController;
  final TextEditingController areaController;
  final TextEditingController addressController;
  final double members;
  final List orderItems;

  const OrderPreview({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.pinController,
    required this.areaController,
    required this.addressController,
    required this.members,
    required this.orderItems,
  });

  @override
  State<OrderPreview> createState() => _OrderPreviewState();
}

class _OrderPreviewState extends State<OrderPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(
          color: AppColors.background
        ),
        title: const Text("Order Preview",
           style: TextStyle(
             color: AppColors.background
           ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Name : ${widget.nameController.text}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "Phone : ${widget.phoneController.text}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "PIN : ${widget.pinController.text}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "Area : ${widget.areaController.text}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "Address : ${widget.addressController.text}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "Members : ${widget.members.toInt()}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              const Divider(height: 35),

              const Text(
                "Selected Items",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              if (widget.orderItems.isEmpty)
                const Text(
                  "No Item Selected",
                  style: TextStyle(color: Colors.grey),
                ),

              if (widget.orderItems.isNotEmpty)
                ...widget.orderItems.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.restaurant,
                          color: Colors.orange,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text("${e.item} (${e.variant})"),
                        ),
                        Text(
                          "x${e.qty}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    await sendWhatsApp();
                  },
                  icon: const Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Send Order on WhatsApp",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendWhatsApp() async {
    final prefs = await SharedPreferences.getInstance();
    final int userId = prefs.getInt("userId") ?? 0;

    String message = "";

    message += "🌿 Bulk Order\n\n";
    message += "Name : ${widget.nameController.text}\n";
    message += "Phone : ${widget.phoneController.text}\n";
    message += "PIN : ${widget.pinController.text}\n";
    message += "Area : ${widget.areaController.text}\n";
    message += "Address : ${widget.addressController.text}\n";
    message += "Members : ${widget.members.toInt()}\n\n";

    message += "Items\n";

    for (var item in widget.orderItems) {
      message += "• ${item.item} (${item.variant}) x ${item.qty}\n";
    }

    const phone = "919696660579";

    final Uri url = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );

    /// Show popup first
    final bool? isSent = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text("Confirm"),
        content: const Text(
          "Do you want to send this order on WhatsApp?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "No",
              style: TextStyle(color: Colors.black),
            ),
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

    /// No -> Stay on same page
    if (isSent != true) return;

    /// Open WhatsApp
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    /// Save Order
    final myOrderVM = context.read<MyOrderVM>();

    await myOrderVM.saveOrder(
      userId,
      MyOrderModel(
        orderType: "Bulk Order",
        items: widget.orderItems.map((e) {
          return MyOrderItem(
            itemId: 0,
            variantId: 0,
            itemName: e.item,
            variantName: e.variant,
            price: 0,
            image: "",
            quantity: e.qty,
          );
        }).toList(),
        address: widget.addressController.text,
        totalAmount: 0,
        orderDate: DateFormat(
          "dd MMM yyyy, hh:mm a",
        ).format(DateTime.now()),
        status: "Order Sent on WhatsApp",
      ),
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MyOrderPage(),
      ),
    );
  }
}