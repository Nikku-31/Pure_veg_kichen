import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Screen/about_us.dart';
import 'package:pure_veg/Screen/address_list_screen.dart';
import 'package:pure_veg/Screen/my_order.dart';
import 'package:pure_veg/Screen/save_address.dart';
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
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Help & Support",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
            
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.red),
                  title: const Text("purevegkitchen03@gmail.com"),
                  onTap: () {
                    Navigator.pop(context);
                    _launchEmail();
                  },
                ),
            
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
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
        backgroundColor: const Color(0xffFAFAFA),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          iconTheme: IconThemeData(
            color:AppColors.background
          ),
          title: Center(
            child: Text("My Profile",
            style: TextStyle(
              color: AppColors.background
            ),),
          ),
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
                color:AppColors.background,
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
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      /// Profile Image
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0,5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [

                              Consumer<ProfileImageVM>(
                                builder: (context, imageVM, child) {
                                  return SizedBox(
                                    width: 95,
                                    height: 95,
                                    child: Stack(
                                      children: [

                                        CircleAvatar(
                                          radius: 45,
                                          backgroundColor: Colors.grey.shade200,
                                          backgroundImage:
                                          imageVM.image != null
                                              ? FileImage(imageVM.image!)
                                              : null,
                                          child: imageVM.image == null
                                              ? const Icon(
                                            CupertinoIcons.person_fill,
                                            size: 42,
                                            color: Colors.grey,
                                          )
                                              : null,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(width: 15),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      user?.name ?? "",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      user?.email ?? "",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          "Quick Action",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                GridView.count(
                  padding: EdgeInsets.all(10),
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
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        const MyOrderPage()));
                      }
                    ),
                    quickActionCard(
                      icon: CupertinoIcons.location_solid,
                      title: "Save Address",
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        const AddressListScreen()));
                      }
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    SizedBox(width: 8),
                    Text(
                      "Preferences",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0B1B4D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height:5),
                   Column(
                    children: [
                      preferenceTile(
                        icon: Icons.info_outline,
                        title: "About us",
                        trailing: const Icon(Icons.arrow_forward),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            const AboutUs()));
                          }
                      ),
                      preferenceTile(
                        icon: Icons.support_agent,
                        title: "Help & Support",
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: _showHelpSupport,
                      ),
                      preferenceTile(
                        icon: Icons.privacy_tip_outlined,
                        title: "Privacy Policy",
                        trailing: const Icon(Icons.arrow_forward),

                      ),
                      preferenceTile(
                        icon: Icons.logout,
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
  Widget preferenceTile({
    required IconData icon,
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

            Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),

            const SizedBox(width: 15),

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
          borderRadius: radius ?? BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// Profile Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    shimmerBox(
                      width: 90,
                      height: 90,
                      radius: BorderRadius.circular(45),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerBox(width: 150, height: 18),
                          const SizedBox(height: 10),
                          shimmerBox(width: 200, height: 14),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Quick Action Heading
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: shimmerBox(width: 140, height: 20),
              ),
            ),

            const SizedBox(height: 15),

            /// Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.6,
                ),
                itemBuilder: (_, __) {
                  return shimmerBox(
                    height: 120,
                    radius: BorderRadius.circular(18),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// Preference Heading
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: shimmerBox(width: 130, height: 20),
              ),
            ),

            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (_, __) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      shimmerBox(
                        width: 24,
                        height: 24,
                        radius: BorderRadius.circular(12),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: shimmerBox(
                          height: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      shimmerBox(
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}