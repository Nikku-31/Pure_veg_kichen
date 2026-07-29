import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Widget/login.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppManager/Model/DashboardM/cart_item_model.dart';
import '../AppManager/Model/DashboardM/menu_item_model.dart';
import '../AppManager/ViewModel/DashboardVM/add_item_vm.dart';
import '../AppManager/ViewModel/DashboardVM/get_variants_vm.dart';
class VariantBottomSheet extends StatefulWidget {
  final String itemId;
  final String itemName;
  final String image;
  final List<AddonModel> addons;
  const VariantBottomSheet({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.image,
    required this.addons,
  });
  @override
  State<VariantBottomSheet> createState() => _VariantBottomSheetState();
}
class _VariantBottomSheetState extends State<VariantBottomSheet> {
  int selectedIndex = 0;
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final vm = Provider.of<GetVariantsVM>(context);
    if (vm.variants.isEmpty) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(widget.itemName,
                      style: TextStyle(
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Icon(
                Icons.info_outline,
                size: 55,
                color: Colors.grey,
              ),
              const SizedBox(height: 15),
               Text("No Variants Available",
                style: TextStyle(
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text("This item has no variants.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppColors.primary, // Green color
                    foregroundColor: Colors.white,            // Text color
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(w * 0.045),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffEEEEEE)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: w * 0.15,
                    width: w * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.fastfood),
                  ),
                  SizedBox(width: w * 0.04),
                  Expanded(
                    child: Text(
                      widget.itemName,
                      style: TextStyle(
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0xffF5F5F7),
              padding: EdgeInsets.all(w * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text("Quantity",
                    style: TextStyle(
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text("Select any 1",
                    style: TextStyle(
                      fontSize: w * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: h * 0.008),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: vm.variants.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      itemBuilder: (context, index) {
                        final variant = vm.variants[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.03,
                              vertical: h * 0.012,
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: w * 0.04),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(variant.label,
                                        style: TextStyle(
                                          fontSize: w * 0.038,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (variant.value.isNotEmpty)
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 4),
                                          child: Text(
                                            variant.value,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Text("₹${variant.price}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: w * 0.038,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Radio<int>(
                                  activeColor:AppColors.primary,
                                  value: index,
                                  groupValue: selectedIndex,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedIndex = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(w * 0.04),
              child: Row(
                children: [
                  Container(
                    height: h * 0.065,
                    width: w * 0.34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                          child: const Icon(
                            Icons.remove,
                            color: Colors.green,
                          ),
                        ),
                        Text(quantity.toString(),
                          style:TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: w * 0.055,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          child: const Icon(
                            Icons.add,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  Expanded(
                    child: SizedBox(
                      height: h * 0.065,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff16A765),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          bool isLogin = prefs.getBool("isLogin") ?? false;
                          if (!isLogin) {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Login(),
                              ),
                            );
                            return;
                          }
                          final selected = vm.variants[selectedIndex];
                          context.read<AddItemVM>().addItem(
                            CartItemModel(
                              itemId: int.parse(widget.itemId),
                              itemName: widget.itemName,
                              variantId: selected.id,
                              variantName: selected.value,
                              price: double.parse(selected.price),
                              image: widget.image,
                              quantity: quantity,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Add Item | ₹${vm.variants[selectedIndex].price}",
                          style: TextStyle(
                            fontSize: w * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}