import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

import '../AppManager/ViewModel/DashboardVM/menu_item_vm.dart';

class MenuItem extends StatefulWidget {
  const MenuItem({super.key});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(
          color: AppColors.background
        ),
        title: Text("Menu Items",
        style: GoogleFonts.poppins(
          color: AppColors.background
        ),),
      ),
      body: SafeArea(
        child: Consumer<MenuItemVM>(
          builder: (context, vm, child) {
        
            if (vm.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.menuItems.length,
                itemBuilder: (context, index) {
                  final item = vm.menuItems[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 120,
                                    height: 150,
                                    child: item.image.isNotEmpty
                                        ? Image.network(
                                      "https://purevegkitchenindia.com/${item.image}",
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    )
                                        : Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.fastfood, size: 40),
                                    ),
                                  ),
                                ),

                                /// + Icon
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Yaha add to cart ya add item ka code likhna hai
                                      print("${item.name} Added");
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8), // Square with rounded corners
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  if (item.description.trim().isNotEmpty) ...[
                                    const SizedBox(height: 5),
                                    Text(item.description),
                                  ],

                                  const SizedBox(height: 8),

                                  Text(
                                    "₹ ${item.price}",
                                    style: const TextStyle(
                                      color: AppColors.primary,
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
      ),

    );
  }
}