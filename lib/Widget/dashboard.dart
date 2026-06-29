import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Screen/wishlist.dart';
import 'package:pure_veg/Widget/profile.dart';
import '../AppManager/ViewModel/CategoriesVM/categories_vm.dart';
import '../core/constants/app_colors.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState(
  );
}
class _DashboardState extends State<Dashboard> {
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
                    const SizedBox(height: 25),
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
                    const SizedBox(height: 20),
                    /// Categories
                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
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
                                  child: categoryCard(
                                    category.icon.isEmpty ? "🍽️" : category.icon,
                                    category.name,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    /// Trending
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          " Trending",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Column(
                      children: [
                        trendingCard(
                          title: "Paneer Tikka",
                          time: "45 min",
                          rating: 4.8,
                          emoji: "🍛",
                        ),
                        trendingCard(
                          title: "Veg Wrap",
                          time: "30 min",
                          rating: 4.5,
                          emoji: "🌯",
                        ),
                        trendingCard(
                          title: "Green Salad",
                          time: "15 min",
                          rating: 4.9,
                          emoji: "🥗",
                        ),
                      ],
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
    return Container(
      width: 90,
      height: 100,
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
    );
  }
  Widget trendingCard({
    required String title,
    required String time,
    required double rating,
    required String emoji,
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
          Text(
            emoji,
            style: const TextStyle(fontSize: 45),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "⏱ $time",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "View Recipe",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}