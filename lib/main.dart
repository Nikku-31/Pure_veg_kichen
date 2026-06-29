import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Widget/login.dart';
import 'package:pure_veg/Widget/splash_screen.dart';
import 'AppManager/ViewModel/DashboardVM/categories_vm.dart';
import 'AppManager/ViewModel/DashboardVM/menu_item_vm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoriesVM()..fetchCategories(),),
        ChangeNotifierProvider(create: (_) => MenuItemVM()..fetchMenuItems(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Pure Veg Kitchen",
        home:const SplashScreen(),
      ),
    );
  }
}
