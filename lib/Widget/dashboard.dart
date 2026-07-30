import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Screen/bulk_order.dart';
import 'package:pure_veg/Screen/menu_item.dart';
import 'package:pure_veg/Screen/wishlist.dart';
import 'package:pure_veg/Widget/login.dart';
import 'package:pure_veg/Widget/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppManager/ViewModel/AccountVM/profile_image_vm.dart';
import '../AppManager/ViewModel/DashboardVM/add_item_vm.dart';
import '../AppManager/ViewModel/DashboardVM/categories_vm.dart';
import '../AppManager/ViewModel/DashboardVM/get_special_vm.dart';
import '../AppManager/ViewModel/DashboardVM/menu_item_vm.dart';
import '../AppManager/ViewModel/DashboardVM/wishlist_vm.dart';
import '../Screen/add_view_item.dart';
import '../Screen/menu_item_cart.dart';
import '../core/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState(
  );
}
class _DashboardState extends State<Dashboard> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> bannerImages = [
    "assets/image/bulk.png",
    "assets/image/login.png",
    "assets/image/signup.jpg",
  ];
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  bool isCategorySelected = false;
  int selectedCategoryIndex = -1;
  bool _isLogin = false;
  @override
  void initState() {
    super.initState();
    _loadLoginStatus();
    Future.microtask(() {
      context.read<AddItemVM>().loadCart();
      context.read<CategoriesVM>().fetchCategories();
      context.read<ProfileImageVM>().loadImage();
      context.read<MenuItemVM>().fetchMenuItems();
      context.read<GetSpecialVM>().fetchSpecialItems();
    });

  }
  Future<void> _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLogin = prefs.getBool("isLogin") ?? false;
    });
  }
  Future<void> _openProfile() async {
    final prefs = await SharedPreferences.getInstance();

    bool isLogin = prefs.getBool("isLogin") ?? false;

    if (isLogin) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const Profile(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const Login(),
        ),
      );
    }
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    return Scaffold(
      backgroundColor:Colors.white,
      body: Stack(
        children: [
          // MAIN UI
          SizedBox.expand(
            child: _selectedIndex == 0
                ? SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  w * 0.04,
                  h * 0.02,
                  w * 0.04,
                  h * 0.11,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            Text(
                              "Welcome! 👋",
                              style: TextStyle(
                                fontSize: w * 0.050,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "To Pure Veg kichen",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: w * 0.035,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _openProfile();
                          },
                          child: Consumer<ProfileImageVM>(
                            builder: (context, imageVM, child) {
                              return CircleAvatar(
                                radius: w * 0.065,
                                backgroundColor: AppColors.primary,
                                backgroundImage: imageVM.image != null
                                    ? FileImage(imageVM.image!)
                                    : null,
                                child: imageVM.image == null
                                    ?  Icon(
                                  CupertinoIcons.person_fill,
                                  color: Colors.white,
                                  size: w * 0.065,
                                )
                                    : null,
                              );
                            },
                          ),
                        ),
                      ],

                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: h * 0.045,
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.012,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100, // ya Colors.grey.shade100
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) async {
                          final vm = context.read<MenuItemVM>();
                          if (value.trim().isNotEmpty) {
                            await vm.fetchMenuItems();
                            vm.searchMenuItems(value);
                            setState(() {
                              isCategorySelected = true;
                              selectedCategoryIndex = -1;
                            });
                          } else {
                            await vm.fetchMenuItems();

                            setState(() {
                              isCategorySelected = false;
                              selectedCategoryIndex = -1;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "Search recipes...",
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          suffixIcon: Icon(
                            CupertinoIcons.search,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Consumer<GetSpecialVM>(
                      builder: (context, vm, child) {

                        if (vm.isLoading) {
                          return  SizedBox(
                            height: h * 0.15,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        return CarouselSlider(
                          options: CarouselOptions(
                            height: h * 0.18,
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                          ),
                          items: vm.specials.map((item) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(w * 0.045),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(w * 0.045),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      item.image,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.black.withOpacity(.65),
                                            Colors.black.withOpacity(.15),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.04,
                                        vertical: h * 0.012,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: w * 0.03,
                                              vertical: h * 0.006,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              item.tagLabel,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: w * 0.03,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            item.itemName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: w * 0.05,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Starting ₹${item.price}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: w * 0.036,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height:2),
                     Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height:5),
                    Consumer<CategoriesVM>(
                      builder: (context, vm, child) {
                        if (vm.isLoading) {
                          return const CategoryShimmer();
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              vm.categories.length,
                                  (index) {
                                final category = vm.categories[index];
                                return Padding(
                                  padding: EdgeInsets.only(right: w * 0.01),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedCategoryIndex == index) {
                                        setState(() {
                                          selectedCategoryIndex = -1;
                                          isCategorySelected = false;
                                          _searchController.clear();
                                        });
                                        context.read<MenuItemVM>().fetchMenuItems();
                                      } else {
                                        setState(() {
                                          selectedCategoryIndex = index;
                                          isCategorySelected = true;
                                          _searchController.clear();
                                        });
                                        context.read<MenuItemVM>().fetchMenuItems(
                                          categoryId: category.id.toString(),
                                        );
                                      }
                                    },
                                    child: categoryCard(
                                      category.image,
                                      category.name,
                                      selectedCategoryIndex == index,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height:8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          " Trending",
                          style: TextStyle(
                            fontSize: w * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MenuItem(),
                              ),
                            ).then((_) {
                              setState(() {
                                isCategorySelected = false;
                              });

                              context.read<MenuItemVM>().fetchMenuItems();
                            });
                          },
                          child: const Text(
                            "View All",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Consumer<MenuItemVM>(
                      builder: (context, vm, child) {
                        print("Loading : ${vm.isLoading}");
                        print("Items : ${vm.menuItems.length}");
                        if (vm.isLoading) {
                          return const TrendingShimmer();
                        }
                        final items = isCategorySelected
                            ? vm.filteredMenuItems
                            : vm.filteredMenuItems.take(6).toList();
                        if (items.isEmpty) {
                          return  Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Text(
                                "No Item Found",
                                style: TextStyle(
                                  fontSize: w * 0.045,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: items
                              .map((item) => MenuItemCard(item: item))
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                :  _selectedIndex == 1
                ? const AddViewItem()
                : _selectedIndex == 2
            ? const BulkOrder()
                : _selectedIndex == 3
            ? const WishlistScreen()
                : const Profile(),
          ),
          if (_selectedIndex == 0)
            Positioned(
              left: w * 0.04,
              right: w * 0.04,
              bottom: h * 0.02,
              child: Consumer<AddItemVM>(
                builder: (context, cartVM, child) {
                  if (cartVM.items.isEmpty) {
                    return const SizedBox();
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddViewItem(),
                        ),
                      );
                    },
                    child: Container(
                      height: h * 0.050,
                      padding: EdgeInsets.symmetric(horizontal: w * 0.045),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(w * 0.04),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${cartVM.totalItem} Item | ₹${cartVM.totalPrice}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "View Item",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                           Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: w * 0.035,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      ],
      ),
      bottomNavigationBar: Consumer<WishlistVM>(
        builder: (context, wishlistVM, child) {
          // Dynamic Wishlist Item Count
          final wishlistCount = wishlistVM.wishlist.length;

          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: "Home",
              ),
              const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.cube_box_fill),
                label: "Order",
              ),
              const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.cart_fill),
                label: "Bulk order",
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  // Agar list empty hai to red badge auto-hide ho jayega
                  isLabelVisible: wishlistCount > 0,
                  backgroundColor: AppColors.primary,
                  label: Text(
                    '$wishlistCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Icon(CupertinoIcons.heart_fill),
                ),
                label: "Saved",
              ),

              if (_isLogin)
                const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person),
                  label: "Profile",
                ),
            ],
          );
        },
      ),
    );
  }
  Widget categoryCard(
      String image,
      String title,
      bool isSelected,
      ) {
    final w = MediaQuery.of(context).size.width;

    return SizedBox(
      width: w * 0.21,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: w * 0.17,
            height: w * 0.14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : Colors.grey.shade300,
                width: isSelected ? 2.5 : 1,
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.fastfood,
                    color: AppColors.primary,
                    size: 28,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: w * 0.028,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? AppColors.primary
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  Widget trendingCard({
    required String title,
    required String description,
    required String price,
    required String image,
  }) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    return Container(

      padding: EdgeInsets.all(w * 0.04),
      margin: EdgeInsets.only(bottom: h * 0.02),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(w * 0.05),
      ),
      child: Row(
        children: [
          image.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(w * 0.025),
            child: Image.network(
              "https://purevegkitchenindia.com/$image",
              width: w * 0.24,
              height: h * 0.14,
              fit: BoxFit.cover,
            ),
          )
              : const Icon(
            Icons.fastfood,
            size: 45,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "₹ $price",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: w * 0.04,
                      ),
                    ),
                  ],
                ),

                if (description.trim().isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],

                const Text(
                  "View Recipe",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class TrendingShimmer extends StatelessWidget {
  const TrendingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        6,
            (index) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 95,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 18,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 14,
                          width: 180,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 14,
                          width: 120,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 16,
                          width: 90,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.11,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.26,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(w * 0.04),
              ),
            ),
          );
        },
      ),
    );
  }
}