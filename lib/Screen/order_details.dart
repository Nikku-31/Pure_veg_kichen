import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/OrderVM/get_order_item_vm.dart';
import '../core/constants/app_colors.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  const OrderDetailsPage({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<GetOrderItemsVM>().getOrderItems(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Order Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Consumer<GetOrderItemsVM>(
        builder: (context, vm, child) {

          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (vm.orderItems.isEmpty) {
            return const Center(
              child: Text(
                "No Items Found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: vm.orderItems.length,
            itemBuilder: (context, index) {

              final item = vm.orderItems[index];

              return Card(
                color: Colors.white,
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight:  Radius.circular(15)
                        ),
                        child: SizedBox(
                          width: 100,
                          child: Image.network(
                            "https://purevegkitchenindia.com/${item.image}",
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.fastfood),
                              );
                            },
                          ),
                        ),
                      ),
                    
                        const SizedBox(width: 10),
                    
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  item.itemName,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "Variant : ${item.variantName ?? "N/A"}",
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "Price : ₹${item.price}",
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "Quantity : ${item.quantity}",
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "Subtotal : ₹${item.subtotal}",
                                  style: const TextStyle(
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
            },
          );
        },
      ),
    );
  }
}