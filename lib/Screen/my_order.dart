import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppManager/ViewModel/OrderVM/get_order_details_vm.dart';
import '../core/constants/app_colors.dart';
import 'order_details.dart';
class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});
  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}
class _MyOrderPageState extends State<MyOrderPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId") ?? 0;
      await context.read<GetOrderDetailsVM>().getOrders(userId);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.background
        ),
        backgroundColor: AppColors.primary,
        title: const Text(
          "My Orders",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<GetOrderDetailsVM>(
          builder: (context, vm, child) {
            if (vm.orderList.isEmpty) {
              return const Center(
                child: Text(
                  "No Orders Found",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: vm.orderList.length,
              itemBuilder: (context, index) {
                final order = vm.orderList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsPage(
                          orderId: order.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.grey.shade300,
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Order Date",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(order.createdAt),
                                  ],
                                ),

                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  order.status,
                                  style: const TextStyle(
                                    color:AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Delivery Address",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      Text(order.customerAddress,
                          style: TextStyle(
                            fontWeight: FontWeight.w500
                          ),),
                          if (order.orderType == "Regular Order")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Amount",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                 Text(
                                   "₹${double.parse(order.totalAmount).toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Text(
                                "Order Stage : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                order.orderStage,
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}