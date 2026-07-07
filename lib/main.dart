import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Widget/login.dart';
import 'package:pure_veg/Widget/splash_screen.dart';
import 'AppManager/ViewModel/AccountVM/edit_profile_vm.dart';
import 'AppManager/ViewModel/AccountVM/login_vm.dart';
import 'AppManager/ViewModel/AccountVM/otp_vm.dart';
import 'AppManager/ViewModel/AccountVM/profile_image_vm.dart';
import 'AppManager/ViewModel/AccountVM/user_profile_vm.dart';
import 'AppManager/ViewModel/DashboardVM/add_item_vm.dart';
import 'AppManager/ViewModel/DashboardVM/categories_vm.dart';
import 'AppManager/ViewModel/DashboardVM/get_variants_vm.dart';
import 'AppManager/ViewModel/DashboardVM/menu_item_vm.dart';
import 'AppManager/ViewModel/DashboardVM/wishlist_vm.dart';
import 'AppManager/ViewModel/LocationVM/get_area_vm.dart';
import 'AppManager/ViewModel/OrderVM/my_order_vm.dart';
import 'AppManager/ViewModel/OrderVM/place_order_vm.dart';

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
        ChangeNotifierProvider(create: (_) => GetVariantsVM(),),
        ChangeNotifierProvider(create: (_) => LoginVM()),
        ChangeNotifierProvider(create: (_) => OtpVM()),
        ChangeNotifierProvider(create: (_) => EditProfileVM(),),
        ChangeNotifierProvider(create: (_) => UserProfileVM(),),
        ChangeNotifierProvider(create: (_) => AddItemVM()),
        ChangeNotifierProvider(create: (_) => GetAreaVM(),),
        ChangeNotifierProvider(create: (_) => WishlistVM()..loadWishlist(),),
        ChangeNotifierProvider(create: (_) => PlaceOrderVM(),),
        ChangeNotifierProvider(create: (_) => MyOrderVM(),),
        ChangeNotifierProvider(create: (_) => ProfileImageVM()..loadImage(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Pure Veg Kitchen",
        home:const SplashScreen(),
      ),
    );
  }
}
