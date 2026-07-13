import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Screen/save_address.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppManager/Model/LocationM/address_model.dart';
import 'Widget/address_provider.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId") ?? 0;

    await context.read<AddressProvider>().loadAddresses(userId);
  }


  IconData _getIcon(String type) {
    switch (type.toLowerCase()) {
      case "home":
        return Icons.home;
      case "work":
        return Icons.work;
      default:
        return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddressProvider>(context);

    return Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          iconTheme: IconThemeData(
            color: AppColors.background
          ),
          title: Text("Save address",style: TextStyle(
            color: AppColors.background,

          ),),
        ),
        body: provider.addresses.isEmpty
            ? const Center(
          child: Text(
            "No Address Found",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        )
            : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.addresses.length,
            itemBuilder: (context, index) {
              AddressModel address = provider.addresses[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Column(
                  children: [
                  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  CircleAvatar(
                  radius: 22,
                  backgroundColor:
                  Colors.orange.withOpacity(.15),
                  child: Icon(
                    _getIcon(address.type),
                    color: Colors.deepOrange,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        address.type,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        address.address,
                        style: const TextStyle(
                          color: Colors.grey,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        address.addressDetails,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "${address.receiverName} • ${address.receiverPhone}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        IconButton(
                          onPressed: () {
                            // Edit Address
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            provider.deleteAddress(index);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
                ),
              );
            },
        ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SaveAddress(
                address: "",
                latitude: 0.0,
                longitude: 0.0,
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          "Add New Address",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}