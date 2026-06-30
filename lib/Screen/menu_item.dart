import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Screen/variant_Bottom_sheet.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../AppManager/ViewModel/DashboardVM/menu_item_vm.dart';
import '../AppManager/ViewModel/DashboardVM/get_variants_vm.dart';
import 'menu_item_cart.dart';

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

                  return MenuItemCard(
                    item: item,
                  );
                },
            );
          },
        ),
      ),
    );
  }
}