import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../AppManager/Model/LocationM/address_model.dart';
import 'Widget/address_provider.dart';
import 'Widget/search_location_screen.dart';
import 'address_list_screen.dart';
class SaveAddress extends StatefulWidget {
  final String address;
  final double latitude;
  final double longitude;

  const SaveAddress({
    super.key,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
  @override
  State<SaveAddress> createState() => _SaveAddressState();
}
class _SaveAddressState extends State<SaveAddress> {

  GoogleMapController? mapController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressDetailsController = TextEditingController();
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController receiverPhoneController = TextEditingController();
  double latitude = 0.0;
  double longitude = 0.0;

  String selectedType = "Home";
  String address = "Fetching current location...";
  @override
  @override
  @override
  void initState() {
    super.initState();

    if (widget.address.isNotEmpty) {
      address = widget.address;
      latitude = widget.latitude;
      longitude = widget.longitude;
    } else {
      getCurrentLocation();
    }
  }
  @override
  void dispose() {
    addressDetailsController.dispose();
    receiverNameController.dispose();
    receiverPhoneController.dispose();
    super.dispose();
  }
  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        address = "Location Service Disabled";
      });
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        address = "Location Permission Denied";
      });
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    latitude = position.latitude;
    longitude = position.longitude;
    List<Placemark> placemark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemark.first;
    setState(() {
      address =
      "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
    });

    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 17,
          ),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .55,
              width: double.infinity,
              child: latitude == 0.0 && longitude == 0.0
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : GoogleMap(
                onMapCreated: (controller) {
                  mapController = controller;
                },

                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 17,
                ),

                myLocationEnabled: true,
                myLocationButtonEnabled: true,

                markers: {
                  Marker(
                    markerId: const MarkerId("current"),
                    position: LatLng(latitude, longitude),
                  ),
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },

                      child: const Icon(Icons.arrow_back,size:28),
                    ),
                    const SizedBox(width:10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {

                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SearchLocationScreen(),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              address = result["address"];
                              latitude = result["latitude"];
                              longitude = result["longitude"];
                            });
                          }
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: AppColors.primary),
                              const SizedBox(width: 10),
                              const Text(
                                "Search for area, street name...",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 190,
              left: 0,
              right: 0,
              child: Icon(
                Icons.location_pin,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            Positioned(
              top: 300,
              left: 90,
              right: 90,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: getCurrentLocation,
                icon: const Icon(Icons.my_location),
                label: const Text("Use current location"),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * .55,
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
                      children: [
                        Container(
                          height: 5,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height:20),
                        addressCard(),
                        const SizedBox(height:20),
                        buildField(
                          controller: addressDetailsController,
                          hint: "Address details*",
                          helper: "E.g. Floor, House no.",
                        ),
                        const SizedBox(height:18),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Receiver details for this address",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height:15),
                        buildField(
                          controller: receiverNameController,
                          hint: "Receiver's Name",
                          helper: "",
                        ),
                        const SizedBox(height:15),
                        buildField(
                          controller: receiverPhoneController,
                          hint: "Receiver's Phone",
                          helper: "",
                        ),
                        const SizedBox(height:20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Save address as",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height:12),
                        Row(
                          children: [
                            addressType(
                              "Home",
                              Icons.home_outlined,
                              selectedType == "Home",
                            ),
                            const SizedBox(width: 10),
                    
                            addressType(
                              "Work",
                              Icons.work_outline,
                              selectedType == "Work",
                            ),
                            const SizedBox(width: 10),
                    
                            addressType(
                              "Other",
                              Icons.location_on_outlined,
                              selectedType == "Other",
                            ),
                          ],
                        ),
                        const SizedBox(height:30),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {

                                final newAddress = AddressModel(
                                  type: selectedType,
                                  address: address,
                                  addressDetails: addressDetailsController.text.trim(),
                                  receiverName: receiverNameController.text.trim(),
                                  receiverPhone: receiverPhoneController.text.trim(),
                                  latitude: latitude,
                                  longitude: longitude,
                                );

                                Provider.of<AddressProvider>(
                                  context,
                                  listen: false,
                                ).addAddress(newAddress);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AddressListScreen(),
                                  ),
                                      (route) => false,
                                );
                              }
                            },
                            child: const Text(
                              "Save address",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget addressCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            Icons.location_on,
            color: AppColors.primary,
          ),

          const SizedBox(width:10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  address,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
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
            keyboardType: hint == "Receiver's Phone"
                ? TextInputType.number
                : TextInputType.text,
            maxLength: hint == "Receiver's Phone" ? 10 : null,
            inputFormatters: hint == "Receiver's Phone"
                ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
                : [],

            validator: (value) {
              if (hint == "Address details*" &&
                  (value == null || value.trim().isEmpty)) {
                return "Please fill address";
              }

              if (hint == "Receiver's Name" &&
                  (value == null || value.trim().isEmpty)) {
                return "Please enter receiver name";
              }

              if (hint == "Receiver's Phone") {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter phone number";
                }

                if (value.length != 10) {
                  return "Please enter a valid 10-digit phone number";
                }
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