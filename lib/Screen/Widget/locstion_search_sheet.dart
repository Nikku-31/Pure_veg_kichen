import 'package:flutter/material.dart';

class LocationSearchSheet extends StatelessWidget {
  const LocationSearchSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: const Center(
        child: Text("Location Search"),
      ),
    );
  }
}