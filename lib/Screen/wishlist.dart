import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> favList = [
      {
        "id": 1,
        "price": "₹ 250000",
        "title": "Residential Plot",
        "subtitle": "Lucknow",
        "details": "1200 sqft · Available",
      },
      {
        "id": 2,
        "price": "₹ 350000",
        "title": "Commercial Plot",
        "subtitle": "Kanpur",
        "details": "1500 sqft · Available",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
               "wishlist",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: AppColors.primary,
          ),
        ),
      ),
      body: favList.isEmpty
          ? Center(
        child: Text(
          "No Favorites",
          style: GoogleFonts.poppins(),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: favList.length,
        itemBuilder: (context, index) {
          final plot = favList[index];

          return propertyCard(
            context: context,
            id: plot["id"],
            price: plot["price"],
            title: plot["title"],
            subtitle: plot["subtitle"],
            details: plot["details"],
            image: "assets/image/icon.png",
          );
        },
      ),
    );
  }
}

Widget propertyCard({
  required BuildContext context,
  required int id,
  required String price,
  required String title,
  required String subtitle,
  required String details,
  required String image,
}) {
  return Card(
    color: Colors.grey.shade100,
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  height: 80,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      details,
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}