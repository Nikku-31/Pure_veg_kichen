import 'package:flutter/material.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../save_address.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  Future<void> getCurrentLocation() async {

    bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) return;

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position =
    await Geolocator.getCurrentPosition();

    List<Placemark> placemarks =
    await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks.first;

    String address =
        "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SaveAddress(
          address: address,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      ),
    );
  }

  Future<void> searchLocation(String value) async {
    if (value.trim().isEmpty) {
      setState(() {
        places.clear();
        loading = false;
      });
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final url = Uri.https(
        "nominatim.openstreetmap.org",
        "/search",
        {
          "q": value,
          "format": "jsonv2",
          "limit": "10",
        },
      );

      final response = await http.get(
        url,
        headers: {
          "User-Agent": "PureVegApp",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          places = (data as List)
              .map((e) => PlaceModel.fromJson(e))
              .toList();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  final TextEditingController searchController = TextEditingController();

  List<PlaceModel> places = [];

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(
          color: AppColors.background
        ),
        title: Text("Select Your Location",
        style: TextStyle(
          color: AppColors.background
        ),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: searchLocation,
                        decoration: InputDecoration(
                          hintText: "Search an area or address",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 18,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: getCurrentLocation,
                      child: Container(
                        height: 72,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.my_location,
                              color: Colors.deepOrange,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Use Current Location",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                
                    Expanded(
                      child: loading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          final place = places[index];
                
                          return ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text(place.displayName),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SaveAddress(
                                    address: place.displayName,
                                    latitude: place.lat,
                                    longitude: place.lon,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceModel {
  final String displayName;
  final double lat;
  final double lon;

  PlaceModel({
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      displayName: json["display_name"],
      lat: double.parse(json["lat"]),
      lon: double.parse(json["lon"]),
    );
  }
}