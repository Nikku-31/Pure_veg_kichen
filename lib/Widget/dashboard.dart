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
import '../AppManager/ViewModel/DashboardVM/menu_item_vm.dart';
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

    return Scaffold(
      backgroundColor:Colors.white,
      body: Stack(
        children: [
          // MAIN UI
          SizedBox.expand(
            child: _selectedIndex == 0
                ? SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Welcome! 👋",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Ready to cook today?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
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
                                radius: 35,
                                backgroundColor: AppColors.primary,
                                backgroundImage: imageVM.image != null
                                    ? FileImage(imageVM.image!)
                                    : null,
                                child: imageVM.image == null
                                    ? const Icon(
                                  CupertinoIcons.person_fill,
                                  color: Colors.white,
                                  size: 35,
                                )
                                    : null,
                              );
                            },
                          ),
                        ),
                      ],

                    ),
                    const SizedBox(height: 15),
                    /// Search
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100, // ya Colors.grey.shade100
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) async {
                          final vm = context.read<MenuItemVM>();
                          if (value.trim().isNotEmpty) {
                            // Search hamesha all items par hoga
                            await vm.fetchMenuItems();
                            vm.searchMenuItems(value);
                            setState(() {
                              isCategorySelected = true;
                              selectedCategoryIndex = -1; // Category highlight hata do
                            });
                          } else {
                            // Search clear hone par normal state
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
                    const SizedBox(height: 10),
                    /// Categories
                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                                  padding: const EdgeInsets.only(right: 12),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedCategoryIndex == index) {
                                        // Same category dubara click hui -> Unselect
                                        setState(() {
                                          selectedCategoryIndex = -1;
                                          isCategorySelected = false;
                                          _searchController.clear();
                                        });

                                        context.read<MenuItemVM>().fetchMenuItems();
                                      } else {
                                        // Nayi category select hui
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
                                      category.icon.isEmpty ? "🍽️" : category.icon,
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
                    const SizedBox(height: 10),
                    /// Trending
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          " Trending",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
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
                    const SizedBox(height: 10),
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
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Text(
                                "No Item Found",
                                style: TextStyle(
                                  fontSize: 18,
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
            ? const BulkOrder()
                : _selectedIndex == 2
            ? const WishlistScreen()
                : const Profile(),
          ),
          if (_selectedIndex == 0)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
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
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${cartVM.totalItem} Item | ₹${cartVM.totalPrice}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Text(
                            "View Item",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18,
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
      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: "Home",),
          const BottomNavigationBarItem(icon: Icon(CupertinoIcons.cart_fill), label: "Bulk order",),
          const BottomNavigationBarItem(icon: Icon(CupertinoIcons.heart_fill), label: "Saved",),
          if (_isLogin)
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: "Profile",
            ),
        ],
      ),
    );
  }
  Widget categoryCard(
      String emoji,
      String title,
      bool isSelected,
      ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
      Container(

      width: 110,
      height: 110,
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade300 : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      ),
      ],
    );
  }
  Widget trendingCard({
    required String title,
    required String description,
    required String price,
    required String image,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          image.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "https://purevegkitchenindia.com/$image",
              width: 95,
              height: 110,
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
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "₹ $price",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        },
      ),
    );
  }
}