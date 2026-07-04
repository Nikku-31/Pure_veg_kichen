import 'package:flutter/material.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/DashboardVM/categories_vm.dart';
import '../AppManager/ViewModel/LocationVM/get_area_vm.dart';
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
  Map<String, List<String>> items = {
    "Starter": [
      "Paneer Tikka",
      "Veg Manchurian",
      "Spring Roll",
    ],
    "Main Course": [
      "Shahi Paneer",
      "Dal Makhani",
      "Mix Veg",
    ],
    "Rice": [
      "Jeera Rice",
      "Veg Biryani",
    ],
    "Bread": [
      "Butter Naan",
      "Tandoori Roti",
    ],
    "Dessert": [
      "Gulab Jamun",
      "Rasgulla",
    ],
  };
  List<String> variants = [
    "Half",
    "Full",
  ];
  String? selectedCategory;
  String? selectedItem;
  String? selectedVariant;
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
                      const SizedBox(height: 18),
                      const Text(
                        "Bulk & Party Orders",
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Feeding a crowd?\nOrder a full Veg Thali Spread",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Fresh home-style food for birthdays,\nparties and office events.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bulk Order",
                    style: TextStyle(
                      color: Colors.green.shade900,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Planning an event? Fill your details below.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
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
                              SizedBox(height: 3),
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
                      const SizedBox(height: 25),
                      buildTextField(
                        controller: nameController,
                        label: "Full Name",
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 15),
                      buildTextField(
                        controller: phoneController,
                        label: "Mobile Number",
                        icon: Icons.phone,
                        keyboard: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      buildTextField(
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
                              value != (context.read<GetAreaVM>().areaData?.pincode ?? "")) {
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
                      const SizedBox(height: 15),
                      buildTextField(
                        controller: areaController,
                        label: "Delivery Area",
                        icon: Icons.location_city,
                        readOnly: true,
                      ),
                      Consumer<GetAreaVM>(
                        builder: (context, vm, child) {
                          if(!vm.isLoading){
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
                                Text(
                                  "Fetching delivery area...",
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isLoadingLocation
                              ? null
                              : getCurrentLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding:
                            const EdgeInsets.symmetric(
                                vertical: 15),
                          ),
                          icon: const Icon(
                            Icons.my_location,
                            color: Colors.white,
                          ),
                          label: Text(
                            isLoadingLocation
                                ? "Getting Location..."
                                : "Pin My Location",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      buildTextField(
                        controller: addressController,
                        label: "Address",
                        icon: Icons.home,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 25),
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
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                      const SizedBox(height: 25),
                      Consumer<CategoriesVM>(
                        builder: (context, vm, child) {

                          if (vm.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration: inputDecoration(
                              "Category",
                              Icons.restaurant_menu,
                            ),
                            items: vm.categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category.name,
                                child: Text(category.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                                selectedItem = null;
                                selectedVariant = null;
                              });

                              // 👇 Yahin se Item API call hogi
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: selectedItem,
                        decoration: inputDecoration(
                          "Item",
                          Icons.fastfood,
                        ),
                        items: (items[selectedCategory] ?? []).map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            selectedItem = v;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: selectedVariant,
                        decoration: inputDecoration(
                          "Variant",
                          Icons.layers,
                        ),
                        items: variants.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            selectedVariant = v;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {
                            if (selectedCategory == null ||
                                selectedItem == null ||
                                selectedVariant == null) {
                              return;
                            }
                            setState(() {
                              orderItems.add(
                                OrderItem(
                                  category: selectedCategory!,
                                  item: selectedItem!,
                                  variant: selectedVariant!,
                                ),
                              );

                              selectedCategory = null;
                              selectedItem = null;
                              selectedVariant = null;
                            });
                          },
                          icon: const Icon(Icons.add,color: Colors.white),
                          label: const Text(
                            "Add Item",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                "3",
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
                                "Order Preview",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Review your order",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 25),
                      Text(
                        "Name : ${nameController.text}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Phone : ${phoneController.text}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "PIN : ${pinController.text}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Area : ${areaController.text}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Address : ${addressController.text}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Members : ${members.toInt()}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Divider(height: 35),
                      const Text(
                        "Selected Items",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if(orderItems.isEmpty)
                        const Text(
                          "No Item Selected",
                          style: TextStyle(color: Colors.grey),
                        ),
                      if(orderItems.isNotEmpty)
                        ...orderItems.map((e){
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.restaurant,
                                  size: 18,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "${e.item} (${e.variant})",
                                  ),
                                ),
                                Text(
                                  "x${e.qty}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: sendWhatsApp,
                          icon: const Icon(
                            Icons.message,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Send Order on WhatsApp",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
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
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Required";
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
  Future<void> sendWhatsApp() async {

    if(!_formKey.currentState!.validate()){
      return;
    }

    if(orderItems.isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please add at least one item"),
        ),
      );

      return;

    }

    String message = "";

    message += "🌿 Bulk Order\n\n";

    message += "Name : ${nameController.text}\n";

    message += "Phone : ${phoneController.text}\n";

    message += "PIN : ${pinController.text}\n";

    message += "Area : ${areaController.text}\n";

    message += "Address : ${addressController.text}\n";
    if(currentPosition!=null){

      message +=
      "Google Map : https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}\n";

    }

    message += "Members : ${members.toInt()}\n\n";

    message += "Items\n";

    for(var item in orderItems){

      message +=
      "• ${item.item} (${item.variant}) x ${item.qty}\n";

    }

    final Uri url = Uri.parse(

        "https://wa.me/919935592408?text=${Uri.encodeComponent(message)}"

    );

    if(await canLaunchUrl(url)){

      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

    }

  }
}