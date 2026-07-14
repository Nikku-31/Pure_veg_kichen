import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/core/constants/app_colors.dart';

import 'Widget/address_provider.dart';
import 'address_list_screen.dart';
import '../AppManager/Model/LocationM/address_model.dart';
class SaveAddress extends StatefulWidget {
  final String address;
  final double latitude;
  final double longitude;

  final bool isFromAddViewItem;

  const SaveAddress({
    super.key,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.isFromAddViewItem = false,
  });
  @override
  State<SaveAddress> createState() => _SaveAddressState();
}
class _SaveAddressState extends State<SaveAddress> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressDetailsController = TextEditingController();
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController receiverPhoneController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController saveAddressAsController = TextEditingController();
  final TextEditingController instructionController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  double latitude = 0.0;
  double longitude = 0.0;

  String selectedType = "House";
  String address = "Fetching current location...";
  @override
  void initState() {
    super.initState();

    address = widget.address;
    latitude = widget.latitude;
    longitude = widget.longitude;
  }
  @override
  void dispose() {
    addressDetailsController.dispose();
    receiverNameController.dispose();
    receiverPhoneController.dispose();
    buildingController.dispose();
    areaController.dispose();
    saveAddressAsController.dispose();
    landmarkController.dispose();
    instructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 55),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Receiver Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          buildField(
                            controller: receiverNameController,
                            hint: "Receiver Name *",
                            helper: "",
                          ),

                          const SizedBox(height: 15),

                          buildField(
                            controller: receiverPhoneController,
                            hint: "Receiver Phone *",
                            helper: "",
                          ),

                          const SizedBox(height: 25),
                          // Location Details
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Location Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          Row(
                            children: [
                              Expanded(
                                child: addressType(
                                  "House",
                                  Icons.home_outlined,
                                  selectedType == "House",
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: addressType(
                                  "Office",
                                  Icons.work_outline,
                                  selectedType == "Office",
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: addressType(
                                  "Other",
                                  Icons.location_on_outlined,
                                  selectedType == "Other",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          buildField(
                            controller: buildingController,
                            hint: "Building / Floor *",
                            helper: "",
                          ),

                          const SizedBox(height: 15),

                          buildField(
                            controller: areaController,
                            hint: "Area / Locality *",
                            helper: "",
                          ),

                          const SizedBox(height: 15),

                          buildField(
                            controller: saveAddressAsController,
                            hint: "Save address as *",
                            helper: "",
                          ),

                          const SizedBox(height: 25),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Landmark (Optional)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          buildField(
                            controller: landmarkController,
                            hint: "Landmark (Optional)",
                            helper: "",
                          ),

                          const SizedBox(height: 25),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Delivery Instructions (Optional)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          buildField(
                            controller: instructionController,
                            hint: "Instructions to reach location",
                            helper: "",
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final newAddress = AddressModel(
                                    type: selectedType,
                                    address: areaController.text.trim(),
                                    addressDetails: buildingController.text.trim(),
                                    receiverName: receiverNameController.text.trim(),
                                    receiverPhone: receiverPhoneController.text.trim(),
                                    latitude: latitude,
                                    longitude: longitude,
                                    addressName: saveAddressAsController.text.trim(),
                                    landmark: landmarkController.text.trim(),
                                    instruction: instructionController.text.trim(),
                                  );

                                   context.read<AddressProvider>().addAddress(newAddress);

                                  if (widget.isFromAddViewItem) {
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const AddressListScreen(),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              child: const Text(
                                "Save Address",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),

                        ]
                    ),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Widget addressCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(15),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15),
  //       border: Border.all(color: Colors.grey.shade300),
  //     ),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //
  //         Icon(
  //           Icons.location_on,
  //           color: AppColors.primary,
  //         ),
  //
  //         const SizedBox(width:10),
  //
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //
  //               Text(
  //                 address,
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget buildField({
    required TextEditingController controller,
    required String hint,
    required String helper,
  }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: hint == "Receiver Phone *"
                ? TextInputType.number
                : TextInputType.text,
            maxLength: hint == "Receiver Phone *" ? 10 : null,
            inputFormatters: hint == "Receiver Phone *"
                ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
                : [],
            validator: (value) {
              if (hint == "Receiver Name *" &&
                  (value == null || value.trim().isEmpty)) {
                return "Please enter receiver name";
              }
              if (hint == "Receiver Phone *") {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter phone number";
                }
                if (value.length != 10) {
                  return "Please enter valid 10 digit phone number";
                }
              }
              if (hint == "Building / Floor *" &&
                  (value == null || value.trim().isEmpty)) {
                return "Please enter Building/Floor";
              }
              if (hint == "Area / Locality *" &&
                  (value == null || value.trim().isEmpty)) {
                return "Please enter Area/Locality";
              }
              if (hint == "Save address as *" &&
                  (value == null || value.trim().isEmpty)) {
                return "Please enter Address Name";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hint,
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          if (helper.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(helper),
            ),
        ],
      );
    }
  Widget addressType(
      String title,
      IconData icon,
      bool selected,
      ) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedType = title;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? AppColors.primary
                  : Colors.black54,
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                color: selected
                    ? AppColors.primary
                    : Colors.black,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}