import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Screen/menu_item.dart';
import 'package:pure_veg/Screen/wishlist.dart';
import 'package:pure_veg/Widget/profile.dart';
import '../AppManager/ViewModel/DashboardVM/categories_vm.dart';
import '../AppManager/ViewModel/DashboardVM/menu_item_vm.dart';
import '../Screen/menu_item_cart.dart';
import '../core/constants/app_colors.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState(
  );
}
class _DashboardState extends State<Dashboard> {
  bool isCategorySelected = false;
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CategoriesVM>().fetchCategories(); // ya jo tumhara method hai

      context.read<MenuItemVM>().fetchMenuItems();
    });
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
                padding: const EdgeInsets.all(16),
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
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 3; // Profile tab index
                            });
                          },
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary,
                            // backgroundImage: NetworkImage(
                            //   "https://your-image-url.com/profile.jpg",
                            // ),
                            child: Icon(
                              CupertinoIcons.person_fill,
                              color: Colors.white,
                              size: 28,
                            ),
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
                      child: const TextField(
                        decoration: InputDecoration(
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
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
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
                                      setState(() {
                                        isCategorySelected = true;
                                      });

                                      context.read<MenuItemVM>().fetchMenuItems(
                                        categoryId: category.id.toString(),
                                      );
                                    },
                                    child: categoryCard(
                                      category.icon.isEmpty ? "🍽️" : category.icon,
                                      category.name,
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
                            );
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
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Column(
                          children: (isCategorySelected
                              ? vm.filteredMenuItems
                              : vm.filteredMenuItems.take(4))
                              .map((item) => MenuItemCard(item: item))
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                : _selectedIndex == 1
                ? const Center(child: Text("Search Screen"))
                : _selectedIndex == 2
                ? const WishlistScreen()
                : const Profile(),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: "Home"),
          BottomNavigationBarItem( icon: Icon(CupertinoIcons.search), label: "Search"),
          BottomNavigationBarItem(  icon: Icon(CupertinoIcons.heart_fill), label: "Saved"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: "Profile"),
        ],
      ),
    );
  }
  Widget categoryCard(
      String emoji,
      String title,
      ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
      Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
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