import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Screen/my_order.dart';
import 'package:pure_veg/Screen/save_address.dart';
import 'package:pure_veg/Widget/login.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppManager/ViewModel/AccountVM/profile_image_vm.dart';
import '../AppManager/ViewModel/AccountVM/user_profile_vm.dart';
import '../AppManager/ViewModel/DashboardVM/add_item_vm.dart';
import '../Screen/edit_profile.dart';
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
    backgroundColor: const Color(0xffF6F8F8),
    body: Stack(
      children: [

      // Green Header
      Container(
      height: 200,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
        ),
      ),
    ),

    SafeArea(
      child: SingleChildScrollView(
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
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

                            const SizedBox(width: 8),

                            const Expanded(
                              child: Text(
                                "My Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

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
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
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
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [

                              Consumer<ProfileImageVM>(
                                builder: (context, imageVM, child) {
                                  return CircleAvatar(
                                    radius: 45,
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage:
                                    imageVM.image != null
                                        ? FileImage(imageVM.image!)
                                        : null,
                                    child: imageVM.image == null
                                        ? const Icon(
                                      CupertinoIcons.person_fill,
                                      size: 40,
                                      color: Colors.grey,
                                    )
                                        : null,
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
                        const SaveAddress()));
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
                        fontSize: 24,
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
                        title: "About us",
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                      preferenceTile(
                        title: "Help & Support",
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                      preferenceTile(
                        title: "Privacy Policy",
                        trailing: const Icon(Icons.arrow_forward),
                      ),
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
               ],
            ),
          ),
        ),
    ]
    )
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