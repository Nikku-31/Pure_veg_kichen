import 'package:flutter/material.dart';
import 'package:pure_veg/core/constants/app_colors.dart';

class OrderPreview extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController pinController;
  final TextEditingController areaController;
  final TextEditingController addressController;
  final double members;
  final List orderItems;
  final VoidCallback onSend;

  const OrderPreview({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.pinController,
    required this.areaController,
    required this.addressController,
    required this.members,
    required this.orderItems,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Preview"),
        backgroundColor: AppColors.primary,
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
                "Name : ${nameController.text}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "Phone : ${phoneController.text}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "PIN : ${pinController.text}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "Area : ${areaController.text}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "Address : ${addressController.text}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "Members : ${members.toInt()}",
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

              if (orderItems.isEmpty)
                const Text(
                  "No Item Selected",
                  style: TextStyle(color: Colors.grey),
                ),

              if (orderItems.isNotEmpty)
                ...orderItems.map((e) {
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
                  onPressed: onSend,
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
}