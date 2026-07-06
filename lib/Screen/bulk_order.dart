import 'package:flutter/material.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../AppManager/Model/DashboardM/menu_item_model.dart';
import '../AppManager/ViewModel/DashboardVM/categories_vm.dart';
import '../AppManager/ViewModel/DashboardVM/get_variants_vm.dart';
import '../AppManager/ViewModel/DashboardVM/menu_item_vm.dart';
import '../AppManager/ViewModel/LocationVM/get_area_vm.dart';
import 'order_preview.dart';
import 'package:flutter/services.dart';
class OrderItem {
  String category;
  String item;
  String variant;
  int qty;

  OrderItem({
    required this.category,
    required this.item,
    required this.variant,
    this.qty = 1,
  });
}
class BulkOrder extends StatefulWidget {
  const BulkOrder({super.key});

  @override
  State<BulkOrder> createState() => _BulkOrderState();
}

class _BulkOrderState extends State<BulkOrder> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedCategoryId;
  String? selectedItemId;
  String? selectedVariant;

  MenuItemModel? selectedMenuItem;
  List<OrderItem> orderItems = [];
  double members = 20;
  Position? currentPosition;
  LatLng? selectedLocation;
  GoogleMapController? mapController;
  bool isLoadingLocation = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesVM>().fetchCategories();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAF8),
      appBar: AppBar(
        backgroundColor:AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Bulk Order",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff1B4332),
                        Color(0xff2D6A4F),
                        Color(0xff40916C),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image + Heading
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Image.asset(
                              "assets/image/bulk.png",
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bulk & Party Orders",
                                  style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Feeding a crowd? Order a full Veg Thali Spread",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // Bottom Description
                      const Text(
                        "Fresh home-style food for birthdays,parties and office events.",
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bulk Order",
                    style: TextStyle(
                      color: Colors.green.shade900,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Planning an event? Fill your details below.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xff1B4332),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text("1",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                "Enter your information",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height:10),
                      buildTextField(
                        controller: nameController,
                        label: "Full Name",
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: phoneController,
                        label: "Mobile Number",
                        icon: Icons.phone,
                        keyboard: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              controller: pinController,
                              label: "PIN Code",
                              icon: Icons.pin_drop,
                              keyboard: TextInputType.number,
                              onChanged: (value) async {
                                if (value.length < 6) {
                                  areaController.clear();
                                  context.read<GetAreaVM>().clearArea();
                                  return;
                                }

                                if (value.length == 6 &&
                                    value !=
                                        (context.read<GetAreaVM>().areaData?.pincode ?? "")) {
                                  final vm = context.read<GetAreaVM>();

                                  bool success = await vm.getAreaByPincode(value);

                                  if (success) {
                                    areaController.text = vm.areaData?.area ?? "";
                                  } else {
                                    areaController.clear();
                                  }
                                }
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: buildTextField(
                              controller: areaController,
                              label: "Delivery Area",
                              icon: Icons.location_city,
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),

                      Consumer<GetAreaVM>(
                        builder: (context, vm, child) {
                          if (!vm.isLoading) {
                            return const SizedBox();
                          }

                          return const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("Fetching delivery area..."),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10,),
                      buildTextField(
                        controller: addressController,
                        label: "Address",
                        icon: Icons.home,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),
                      if (selectedLocation != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 15,),
                          child: SizedBox(height: 220,
                            child: GoogleMap(
                              initialCameraPosition:
                              CameraPosition(
                                target: selectedLocation!,
                                zoom: 16,
                              ),
                              markers: {
                                Marker(
                                  markerId:
                                  const MarkerId("location"),
                                  position:
                                  selectedLocation!,
                                ),
                              },
                              onMapCreated: (controller) {
                                mapController = controller;
                              },
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          const Icon(
                            Icons.groups,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Number of Members",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            members.toInt().toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.orange,
                            ),
                          )
                        ],
                      ),
                      Slider(
                        value: members,
                        min: 20,
                        max: 100,
                        divisions: 80,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            members = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height:10),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade200,
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xff1B4332),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                "2",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pick Your Dishes",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Select category, item & variant",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height:15),
                      Consumer<CategoriesVM>(
                        builder: (context, vm, child) {

                          if (vm.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return DropdownButtonFormField<String>(
                            value: selectedCategoryId,
                            decoration: inputDecoration(
                              "Category",
                              Icons.restaurant_menu,
                            ),
                            items: vm.categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category.id.toString(),
                                child: Text(category.name),
                              );
                            }).toList(),
                            onChanged: (value) async {
                              setState(() {
                                selectedCategoryId = value;
                                selectedItemId = null;
                                selectedVariant = null;
                                selectedMenuItem = null;
                              });
                              await context.read<MenuItemVM>().fetchMenuItems(
                                categoryId: value,
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Consumer<MenuItemVM>(
                        builder: (context, itemVM, child) {

                          if (itemVM.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return DropdownButtonFormField<String>(
                            value: selectedItemId,
                            decoration: inputDecoration(
                              "Item",
                              Icons.fastfood,
                            ),
                            items: itemVM.menuItems.map((item) {
                              return DropdownMenuItem<String>(
                                value: item.id,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.55,
                                  child: Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) async {
                              final item = itemVM.menuItems.firstWhere(
                                    (e) => e.id == value,
                              );
                              setState(() {
                                selectedItemId = value;
                                selectedMenuItem = item;
                                selectedVariant = null;
                              });

                              await context.read<GetVariantsVM>().getVariants(
                                int.parse(item.id),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 10),
                      Consumer<GetVariantsVM>(
                        builder: (context, variantVM, child) {

                          if (variantVM.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return DropdownButtonFormField<String>(
                            value: selectedVariant,
                            decoration: inputDecoration(
                              "Variant",
                              Icons.layers,
                            ),
                            items: variantVM.variants.map((variant) {
                              return DropdownMenuItem<String>(
                                value: variant.value,
                                child: Text(
                                  "${variant.label} (${variant.price})",
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedVariant = value;
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {
                            if (selectedCategoryId == null ||
                                selectedMenuItem == null ||
                                selectedVariant == null) {
                              return;
                            }
                            setState(() {
                              orderItems.add(
                                OrderItem(
                                  category: selectedCategoryId!,
                                  item: selectedMenuItem!.name,
                                  variant: selectedVariant!,
                                ),
                              );

                              selectedCategoryId = null;
                              selectedItemId = null;
                              selectedVariant = null;
                              selectedMenuItem = null;
                            });
                          },
                          icon: const Icon(Icons.add,color: Colors.white),
                          label: const Text(
                            "Add Item",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if(orderItems.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "No Item Added",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      if(orderItems.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderItems.length,
                          itemBuilder: (context,index){
                            final item=orderItems[index];
                            return Card(
                              color: AppColors.background,
                              child: ListTile(
                                title: Text(item.item),
                                subtitle: Text(item.variant),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.orange.shade100,
                                  child: const Icon(Icons.restaurant),
                                ),
                                trailing: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(4),
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          if (item.qty > 1) {
                                            setState(() {
                                              item.qty--;
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.remove_circle),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          item.qty.toString(),
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(4),
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          setState(() {
                                            item.qty++;
                                          });
                                        },
                                        icon: const Icon(Icons.add_circle),
                                      ),
                                      IconButton(
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(4),
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          setState(() {
                                            orderItems.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {

                      // Form validation
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      // At least one item selected hona chahiye
                      if (orderItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please add at least one item"),
                          ),
                        );
                        return;
                      }

                      // Sab sahi hai to next page open hoga
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderPreview(
                            nameController: nameController,
                            phoneController: phoneController,
                            pinController: pinController,
                            areaController: areaController,
                            addressController: addressController,
                            members: members,
                            orderItems: orderItems,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onChanged: (value) {
        setState(() {});
        if(onChanged!=null){
          onChanged(value);
        }
      },
      keyboardType: keyboard,
      inputFormatters: controller == phoneController
          ? [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ]
          : controller == pinController
          ? [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ]
          : null,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Required";
        }
        if (controller == phoneController) {
          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
            return "Enter valid 10 digit mobile number";
          }
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
  InputDecoration inputDecoration(
      String text,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: text,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
}
  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission =
      await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      setState(() {
        isLoadingLocation = true;
      });
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placeMarks =
      await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placeMarks.first;
      addressController.text =
      "${place.street}, ${place.locality}, ${place.postalCode}";
      pinController.text = place.postalCode ?? "";
      final vm = context.read<GetAreaVM>();
      if (pinController.text.length == 6) {
        bool success = await vm.getAreaByPincode(pinController.text);
        if (success) {
          areaController.text = vm.areaData?.area ?? "";
        }
      }
      currentPosition = position;
      selectedLocation = LatLng(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }
  // Future<void> sendWhatsApp() async {
  //
  //   if(!_formKey.currentState!.validate()){
  //     return;
  //   }
  //
  //   if(orderItems.isEmpty){
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Please add at least one item"),
  //       ),
  //     );
  //
  //     return;
  //
  //   }
  //
  //   String message = "";
  //
  //   message += "🌿 Bulk Order\n\n";
  //
  //   message += "Name : ${nameController.text}\n";
  //
  //   message += "Phone : ${phoneController.text}\n";
  //
  //   message += "PIN : ${pinController.text}\n";
  //
  //   message += "Area : ${areaController.text}\n";
  //
  //   message += "Address : ${addressController.text}\n";
  //   if(currentPosition!=null){
  //
  //     message +=
  //     "Google Map : https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}\n";
  //
  //   }
  //
  //   message += "Members : ${members.toInt()}\n\n";
  //
  //   message += "Items\n";
  //
  //   for(var item in orderItems){
  //
  //     message +=
  //     "• ${item.item} (${item.variant}) x ${item.qty}\n";
  //
  //   }
  //
  //   const phone = "919935592408";
  //
  //   final Uri url = Uri.parse(
  //     "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
  //   );
  //
  //   try {
  //     await launchUrl(
  //       url,
  //       mode: LaunchMode.externalApplication,
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Unable to open WhatsApp"),
  //       ),
  //     );
  //   }
  //
  // }
}