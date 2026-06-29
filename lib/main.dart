import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Widget/login.dart';
import 'package:pure_veg/Widget/splash_screen.dart';

import 'AppManager/ViewModel/CategoriesVM/categories_vm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoriesVM()..fetchCategories(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Pure Veg Kitchen",
        home:const SplashScreen(),
      ),
    );
  }
}
