import 'package:flutter/material.dart';
import 'package:pure_veg/Widget/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pure Veg Kitchen",
      home:const Login(),
    );
  }
}
