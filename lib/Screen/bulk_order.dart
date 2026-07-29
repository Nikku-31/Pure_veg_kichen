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
  int itemId;
  int variantId;
  String category;
  String item;
  String variant;
  String unit;
  int qty;

  OrderItem({
    required this.itemId,
    required this.variantId,
    required this.category,
    required this.item,
    required this.variant,
    required this.unit,
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
  final TextEditingController quantityController = TextEditingController();
  String? selectedCategoryId;
  String? selectedItemId;
  String? selectedVariant;
  String? selectedUnit;

  final List<String> units = [
    "Pieces",
    "Plate(s)",
    "Kg",
    "Gram",
    "Litre",
    "ML",
    "❓ Not Sure — Ask Owner",
  ];

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
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
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
          padding: EdgeInsets.all(w * 0.040),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(w * 0.055),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w * 0.06),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(w * 0.20),
                            child: Image.asset(
                              "assets/image/bulk.png",
                              width: w * 0.17,
                              height: w * 0.17,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: w * 0.05),

                           Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bulk & Party Orders",
                                  style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.038,
                                  ),
                                ),
                                SizedBox(height: h * 0.005),
                                Text(
                                  "Feeding a crowd? Order a full Veg Thali Spread",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.035,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.004),
                       Text(
                        "Fresh home-style food for birthdays,parties and office events.",
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: w * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h * 0.002),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bulk Order",
                    style: TextStyle(
                      color: Colors.green.shade900,
                      fontSize: w * 0.050,
                      fontWeight: FontWeight.w500,
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
                SizedBox(height: h * 0.010),
                Container(
                  padding: EdgeInsets.all(w * 0.040),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w * 0.050),
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
                            height: w * 0.070,
                            width: w * 0.070,
                            decoration: BoxDecoration(
                              color: const Color(0xff1B4332),
                              borderRadius: BorderRadius.circular(w * 0.03),
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
                          SizedBox(width: w * 0.04),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.035,
                                ),
                              ),
                              Text(
                                "Enter your information",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: w * 0.025,
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
                      const SizedBox(height:10),
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
                          SizedBox(width: w * 0.02),
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
                          return  Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: w * 0.045,
                                  height: w * 0.040,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width:8),
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
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      if (selectedLocation != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 15,),
                          child: SizedBox(height: h * 0.28,
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
                          SizedBox(width: w * 0.025),
                          const Text(
                            "Number of Members",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            members.toInt().toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: w * 0.045,
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
                        activeColor:AppColors.primary,
                        onChanged: (value) {
                          setState(() {
                            members = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height:8),
                Container(
                  padding: EdgeInsets.all(w * 0.045),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w * 0.05),
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
                            height: w * 0.070,
                            width: w * 0.070,
                            decoration: BoxDecoration(
                              color: const Color(0xff1B4332),
                              borderRadius: BorderRadius.circular(w * 0.03),
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
                          SizedBox(width: w * 0.02),
                           Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pick Your Dishes",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  fontSize: w * 0.035,),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Select category, item & variant",
                                style: TextStyle(
                                    color: Colors.grey,
                                  fontSize: w * 0.025,),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height:8),
                      Consumer<CategoriesVM>(
                        builder: (context, vm, child) {

                          if (vm.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return DropdownButtonFormField<String>(
                            value: selectedCategoryId,
                            dropdownColor: Colors.white,
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
                            dropdownColor: Colors.white,
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
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: inputDecoration(
                          "Quantity",
                          Icons.shopping_cart,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedUnit,
                        dropdownColor: Colors.white,
                        decoration: inputDecoration(
                          "Unit",
                          Icons.inventory_2_outlined,
                        ),
                        hint: const Text("Select Unit"),
                        items: units.map((unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedUnit = value;
                          });
                        },
                      ),
                      const SizedBox(height:5),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:Colors.orange,
                            padding: EdgeInsets.symmetric(vertical: h * 0.013),
                          ),
                          onPressed: () {
                            if (selectedCategoryId == null ||
                                selectedMenuItem == null ||
                                quantityController.text.isEmpty ||
                                selectedUnit == null) {
                              return;
                            }
                            setState(() {
                              orderItems.add(
                                OrderItem(
                                  itemId: int.parse(selectedMenuItem!.id),
                                  variantId: 0,
                                  category: selectedCategoryId!,
                                  item: selectedMenuItem!.name,
                                  variant: "",
                                  unit: selectedUnit!,
                                  qty: int.parse(quantityController.text),
                                ),
                              );
                              selectedCategoryId = null;
                              selectedItemId = null;
                              selectedMenuItem = null;
                              selectedUnit = null;
                              quantityController.clear();
                            });
                          },
                          icon: const Icon(Icons.add,color: Colors.white),
                          label:Text(
                            "Add Item",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.03,
                            ),
                          )
                        ),
                      ),
                      const SizedBox(height: 5),
                      if(orderItems.isEmpty)
                         Center(
                          child: Padding(
                            padding: EdgeInsets.all(w * 0.05),
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
                                subtitle: Text("Quantity : ${item.qty} ${item.unit}"),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  child: const Icon(Icons.restaurant,
                                  color: AppColors.primary,),
                                ),
                                trailing: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.all(w * 0.01),
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
                                        padding: EdgeInsets.all(w * 0.01),
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
                                        padding: EdgeInsets.all(w * 0.01),
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
                const SizedBox(height:8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: h * 0.013),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      if (orderItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please add at least one item"),
                          ),
                        );
                        return;
                      }
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
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.04,
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
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
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
      floatingLabelStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w300,
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.black54,
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
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