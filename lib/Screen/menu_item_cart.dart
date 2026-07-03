import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../AppManager/Model/DashboardM/menu_item_model.dart';
import '../AppManager/ViewModel/DashboardVM/get_variants_vm.dart';
import '../Screen/variant_Bottom_sheet.dart';
import '../core/constants/app_colors.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItemModel item;

  const MenuItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
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
                      )
                          : Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.fastfood,
                          size: 40,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () async {
                        final variantVM = Provider.of<GetVariantsVM>(
                          context,
                          listen: false,
                        );

                        final itemId = int.tryParse(item.id);

                        if (itemId == null) return;

                        await variantVM.getVariants(itemId);

                        if (!context.mounted) return;

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (_) => VariantBottomSheet(
                            itemId: item.id,
                            itemName: item.name,
                            image: item.image,
                          )
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
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
  }
}