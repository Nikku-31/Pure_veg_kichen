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

  // Get current stage index
  int _getStageIndex(String stage) {
    final value = stage.toLowerCase().trim();

    if (value.contains("placed")) {
      return 0;
    } else if (value.contains("making") ||
        value.contains("preparing") ||
        value.contains("processing")) {
      return 1;
    } else if (value.contains("ready")) {
      return 2;
    } else if (value.contains("delivered") ||
        value.contains("complete") ||
        value.contains("completed")) {
      return 3;
    }

    return 0;
  }

  // Status color
  Color _getStatusBackground(String status) {
    final value = status.toLowerCase().trim();

    if (value == "approved") {
      return const Color(0xffC9EBC7);
    }

    if (value == "pending") {
      return const Color(0xffF9DFA3);
    }

    return const Color(0xffE5E5E5);
  }

  Color _getStatusTextColor(String status) {
    final value = status.toLowerCase().trim();

    if (value == "approved") {
      return const Color(0xff19751B);
    }

    if (value == "pending") {
      return const Color(0xff8A5A12);
    }

    return Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "My orders",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
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
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15,),
              itemCount: vm.orderList.length,
              itemBuilder: (context, index) {
                final order = vm.orderList[index];
                final int currentStage =
                _getStageIndex(order.orderStage);
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
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 18,),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xffE1E1E1),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "Ordered ${order.createdAt}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize:13,
                                  color: Color(0xff929292),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical:2,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusBackground(
                                  order.status,
                                ),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Text(
                                order.status,
                                style: TextStyle(
                                  color: _getStatusTextColor(
                                    order.status,
                                  ),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                order.customerAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize:18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height:5),
                        _OrderProgress(
                          currentStage: currentStage,
                        ),
                        const SizedBox(height: 3),
                      ],
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

class _OrderProgress extends StatelessWidget {
  final int currentStage;

  const _OrderProgress({
    required this.currentStage,
  });

  final List<String> stages = const [
    "Placed", "Making", "Ready", "Delivered",];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            stages.length * 2 - 1,
                (index) {
              // DOT
              if (index.isEven) {
                final int stageIndex = index ~/ 2;

                final bool isCompleted =
                    stageIndex < currentStage;

                final bool isCurrent =
                    stageIndex == currentStage;

                if (isCurrent) {
                  if (stageIndex == 3) {
                    return Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff009B12),
                      ),
                    );
                  }

                  return Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xffF4A51C),
                      border: Border.all(
                        color: const Color(0xffF9E7C3),
                        width: 6,
                      ),
                    ),
                  );
                }

                return Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? const Color(0xff009B12)
                        : const Color(0xffCCCCCC),
                  ),
                );
              }
              final int lineIndex = index ~/ 2;

              final bool isCompleted =
                  lineIndex < currentStage;

              return Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  color: isCompleted
                      ? const Color(0xffC8B99E)
                      : const Color(0xffE3E3E3),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 7),
        Row(
          children: List.generate(
            stages.length,
                (index) {
              final bool isCurrent =
                  index == currentStage;

              return Expanded(
                child: Text(
                  stages[index],
                  textAlign: index == 0
                      ? TextAlign.left
                      : index == stages.length - 1
                      ? TextAlign.right
                      : TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isCurrent
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: isCurrent
                        ? const Color(0xff8A5A12)
                        : const Color(0xff8D8D8D),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}