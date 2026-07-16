import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Screen/about_us.dart';
import 'package:pure_veg/Screen/address_list_screen.dart';
import 'package:pure_veg/Screen/my_order.dart';
import 'package:pure_veg/Widget/login.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AppManager/ViewModel/AccountVM/profile_image_vm.dart';
import '../AppManager/ViewModel/AccountVM/user_profile_vm.dart';
import '../AppManager/ViewModel/DashboardVM/add_item_vm.dart';
import '../Screen/edit_profile.dart';
import 'package:shimmer/shimmer.dart';

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

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri.parse(
      "mailto:purevegkitchen03@gmail.com?subject=Support&body=Hello",
    );
    try {
      await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '4562485585',
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _showHelpSupport() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  "Help & Support",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0B1B4D),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.shade50,
                    child: const Icon(Icons.email, color: Colors.red),
                  ),
                  title: const Text("purevegkitchen03@gmail.com"),
                  onTap: () {
                    Navigator.pop(context);
                    _launchEmail();
                  },
                ),
                const Divider(height: 24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade50,
                    child: const Icon(Icons.phone, color: Colors.green),
                  ),
                  title: const Text("4562485585"),
                  onTap: () {
                    Navigator.pop(context);
                    _launchPhone();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt("userId") ?? 0;
    if (id != 0) {
      await Provider.of<UserProfileVM>(
        context,
        listen: false,
      ).getProfile(id);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UserProfileVM>(context);
    final user = vm.user;
    if (vm.isLoading) {
      return const ProfileShimmer();
    }
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(
            color: Colors.white),
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
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
              Icons.edit_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 20, left: 10, right: 20, top: 20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Consumer<ProfileImageVM>(
                        builder: (context, imageVM, child) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 3),
                            ),
                            child: CircleAvatar(
                              radius: 38,
                              backgroundColor: Colors.grey.shade100,
                              backgroundImage: imageVM.image != null
                                  ? FileImage(imageVM.image!)
                                  : null,
                              child: imageVM.image == null
                                  ? Icon(
                                CupertinoIcons.person_fill,
                                size: 36,
                                color: Colors.grey.shade400,
                              )
                                  : null,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? "User Name",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff0B1B4D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? "email@example.com",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Quick Action",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xff0B1B4D),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.4,
                  children: [
                    quickActionCard(
                      icon: CupertinoIcons.cube_box_fill,
                      title: "My Order",
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrderPage()));
                      },
                    ),
                    quickActionCard(
                      icon: CupertinoIcons.location_solid,
                      title: "Save Address",
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressListScreen()));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Preferences Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Preferences",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0B1B4D),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    preferenceTile(
                      icon: Icons.info_outline,
                      title: "About us",
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUs()));
                      },
                    ),
                    const Divider(height: 1, indent: 56, endIndent: 16),
                    preferenceTile(
                      icon: Icons.support_agent,
                      title: "Help & Support",
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: _showHelpSupport,
                    ),
                    const Divider(height: 1, indent: 56, endIndent: 16),
                    preferenceTile(
                      icon: Icons.privacy_tip_outlined,
                      title: "Privacy Policy",
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    ),
                    const Divider(height: 1, indent: 56, endIndent: 16),
                    preferenceTile(
                      icon: Icons.logout,
                      title: "Logout",
                      textColor: Colors.redAccent,
                      trailing: const Icon(Icons.chevron_right, color: Colors.redAccent),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
                              content: const Text("Are you sure you want to logout?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () async {
                                    await context.read<AddItemVM>().clearCart(
                                      removeStorage: false,
                                    );
                                    final prefs = await SharedPreferences.getInstance();
                                    final int userId = prefs.getInt("userId") ?? 0;
                                    await prefs.remove("addons_$userId");
                                    await prefs.remove("isLogin");
                                    await prefs.remove("userId");

                                    await prefs.remove("userEmail");
                                    Navigator.pop(context);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (_) => const Login()),
                                          (route) => false,
                                    );
                                  },
                                  child: const Text("Logout", style: TextStyle(color: Colors.white)),
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
              const SizedBox(height: 24),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff0B1B4D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget preferenceTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    Color textColor = const Color(0xff0B1B4D),
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: textColor == Colors.redAccent
                      ? Colors.red.shade50
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: textColor == Colors.redAccent ? Colors.redAccent : AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  Widget shimmerBox({
    double? width,
    double? height,
    BorderRadius? radius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    shimmerBox(
                      width: 64,
                      height: 64,
                      radius: BorderRadius.circular(32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          shimmerBox(width: 140, height: 18),
                          const SizedBox(height: 8),
                          shimmerBox(width: 180, height: 14),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: shimmerBox(width: 120, height: 20),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.4,
                ),
                itemBuilder: (_, __) => shimmerBox(radius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: shimmerBox(width: 110, height: 20),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (_, __) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        shimmerBox(width: 36, height: 36, radius: BorderRadius.circular(10)),
                        const SizedBox(width: 16),
                        Expanded(child: shimmerBox(height: 16)),
                        const SizedBox(width: 16),
                        shimmerBox(width: 20, height: 20, radius: BorderRadius.circular(6)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}