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
                  child: ListTile(
                    leading: SizedBox(
                      width: 70,
                      height: 110,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: item.image.isNotEmpty
                            ? Image.network(
                          "https://purevegkitchenindia.com/${item.image}",
                          fit: BoxFit.cover,
                        )
                            : const Icon(
                          Icons.fastfood,
                          size: 50,
                        ),
                      ),
                    ),
        
                    title: Text(item.name),
        
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
        
                        Text(item.description),
        
                        const SizedBox(height: 5),
        
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
                );
              },
            );
          },
        ),
      ),

    );
  }
}