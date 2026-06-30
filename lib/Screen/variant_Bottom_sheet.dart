import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../AppManager/ViewModel/DashboardVM/get_variants_vm.dart';

class VariantBottomSheet extends StatefulWidget {
  final String itemName;

  const VariantBottomSheet({
    super.key,
    required this.itemName,
  });

  @override
  State<VariantBottomSheet> createState() =>
      _VariantBottomSheetState();
}

class _VariantBottomSheetState
    extends State<VariantBottomSheet> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<GetVariantsVM>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Text(
            widget.itemName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          ListView.builder(
            shrinkWrap: true,
            itemCount: vm.variants.length,
            itemBuilder: (context, index) {

              final variant = vm.variants[index];

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio<int>(
                  value: index,
                  groupValue: selectedIndex,
                  onChanged: (value) {
                    setState(() {
                      selectedIndex = value!;
                    });
                  },
                ),
                title: Text(variant.label),
                subtitle: Text(variant.value),
                trailing: Text(
                  "₹${variant.price}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {

                final selected =
                vm.variants[selectedIndex];

                print(selected.label);
                print(selected.price);

                Navigator.pop(context);

                /// Cart API yaha call hogi
              },
              child: const Text("ADD"),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}