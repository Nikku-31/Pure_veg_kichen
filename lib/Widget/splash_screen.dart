import 'package:flutter/material.dart';
import 'package:pure_veg/Widget/dashboard.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/image/splash.png",
              fit: BoxFit.cover,
            ),
          ),

          /// Dark Overlay
          Container(
            color: Colors.black.withOpacity(0.45),
          ),

          /// Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  //
                  // /// App Name
                  // const Text(
                  //   "Pretty\nYummy",
                  //   textAlign: TextAlign.center,
                  //   style: GoogleFonts.poppins(
                  //     fontSize: 48,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.tealAccent,
                  //     height: 1.1,
                  //   ),
                  // ),

                  // const SizedBox(height: 20),
                  //
                  // const Text(
                  //   "Fresh & Delicious Vegetarian Food\nDelivered To Your Doorstep",
                  //   textAlign: TextAlign.center,
                  //   style: GoogleFonts.poppins(
                  //     color: Colors.white,
                  //     fontSize: 16,
                  //     height: 1.5,
                  //   ),
                  // ),

                  const SizedBox(height: 80),

                  /// Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Dashboard(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.05),
                        ),
                      ),
                      child: Text(
                        "Get Started",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}