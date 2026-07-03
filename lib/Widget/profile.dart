import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Screen/edit_profile.dart';
import 'package:pure_veg/Screen/save_address.dart';
import 'package:pure_veg/Widget/login.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppManager/ViewModel/AccountVM/user_profile_vm.dart';
import '../AppManager/ViewModel/DashboardVM/add_item_vm.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  String name = "";
  String email = "";
  String phone = "";
  String address = "";
  int id = 0;
  File? profileImage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getInt("userId") ?? 0;

    if (id != 0) {
      await Provider.of<UserProfileVM>(
        context,
        listen: false,
      ).getProfile(id);

      if (mounted) {
        setState(() {});
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UserProfileVM>(context);
    final user = vm.user;
    if (vm.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SingleChildScrollView(
        child: SafeArea(
          top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Profile Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    20, // left
                    50, // top)
                    16, // right
                    16, // bottom
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                   color: AppColors.primary
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Top Row
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage:
                            profileImage != null ? FileImage(profileImage!) : null,
                            child: profileImage == null
                                ? const Text(
                              "👨‍🍳",
                              style: TextStyle(fontSize: 40),
                            )
                                : null,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  user?.email ?? "",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditProfile(
                                      id: user?.id ?? 0,
                                      name: user?.name ?? "",
                                      email: user?.email ?? "",
                                      phone: user?.phone ?? "",
                                    ),
                                  ),
                                );

                                if (result == true) {
                                  await loadProfile();
                                }
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Passionate about healthy vegetarian cooking and exploring new recipes! 🍲",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          height: 1.4,
                        ),
                      ),
                    ],

                  ),
                ),
                const SizedBox(height: 20),
                /// Quick Actions
                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0B1B4D),
                  ),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.6,
                  children: [
                    quickActionCard(
                      icon: CupertinoIcons.cube_box_fill,
                      title: "My Order",
                    ),
                    quickActionCard(
                      icon: CupertinoIcons.location_solid,
                      title: "Save Address",
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        const SaveAddress()));
                      }
                    ),
                    quickActionCard(
                      icon: CupertinoIcons.arrow_counterclockwise_circle_fill,
                      title: "My Refund",
                    ),
                    quickActionCard(
                      icon: CupertinoIcons.star_circle_fill,
                      title: "Badges",
                    ),
                  ],
                ),
                // const SizedBox(height: 30),
                // /// Recent Activity
                // const Row(
                //   children: [
                //     Icon(
                //       Icons.menu_book_outlined,
                //       color: Colors.blueGrey,
                //       size: 22,
                //     ),
                //     SizedBox(width: 8),
                //     Text(
                //       "Recent Activity",
                //       style: TextStyle(
                //         fontSize: 24,
                //         fontWeight: FontWeight.bold,
                //         color: Color(0xff0B1B4D),
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 16),
                // activityCard(
                //   title: "Paneer Tikka Masala",
                //   subtitle: "Cooked 2 days ago",
                //   trailing: "⭐ 4.8",
                // ),
                // const SizedBox(height: 14),
                // activityCard(
                //   title: "Buddha Bowl",
                //   subtitle: "Liked 5 days ago",
                //   trailing: "💗",
                // ),
                // const SizedBox(height: 14),
                // activityCard(
                //   title: "Veg Pasta Primavera",
                //   subtitle: "Viewed 1 week ago",
                //   trailing: "⭐ 4.7",
                // ),
                const SizedBox(height: 30),
                /// Preferences
                const Row(
                  children: [
                    SizedBox(width: 8),
                    Text(
                      "Preferences",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0B1B4D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      preferenceTile(
                        title: "About us",
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                      Divider(height: 1),
                      preferenceTile(
                        title: "Notifications",
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                      // Divider(height: 1),
                      // preferenceTile(
                      //   title: "Dark Mode",
                      //   trailing: Switch(
                      //     value: false,
                      //     onChanged: (value) {},
                      //   ),
                      // ),
                      Divider(height: 1),
                      preferenceTile(
                        title: "Language",
                        trailing: const Text(
                          "English",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Divider(height: 1),
                      preferenceTile(
                        title: "Help & Support",
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                /// Account
                const Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0B1B4D),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      preferenceTile(
                        title: "Email & Password",
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                      const Divider(height: 1),
                      preferenceTile(
                        title: "Privacy Policy",
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                      const Divider(height: 1),
                      preferenceTile(
                        title: "Logout",
                        textColor: Colors.red,
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: const Text("Logout"),
                                content: const Text(
                                  "Are you sure you want to logout?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () async {
                                      // Cart Clear
                                     await context.read<AddItemVM>().clearCart();
                                     final prefs = await SharedPreferences.getInstance();

                                     await prefs.remove("isLogin");
                                      await prefs.remove("userId");
                                      await prefs.remove("userEmail");

                                      Navigator.pop(context);

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const Login(),
                                        ),
                                            (route) => false,
                                      );
                                    },
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
  Widget quickActionCard({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 34,
              color: AppColors.primary,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff0B1B4D),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget activityCard({
    required String title,
    required String subtitle,
    required String trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0B1B4D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  Widget preferenceTile({
    required String title,
    required Widget trailing,
    Color textColor = const Color(0xff0B1B4D),
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}