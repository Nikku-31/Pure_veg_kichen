import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Widget/dashboard.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppManager/ViewModel/AccountVM/edit_profile_vm.dart';
import '../AppManager/ViewModel/AccountVM/profile_image_vm.dart';
import '../Widget/profile.dart';

class EditProfile extends StatefulWidget {
  final int id;
  final String name;
  final String email;
  final String phone;
  final bool fromOtp;
  const EditProfile({super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.fromOtp = false,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });

      await context.read<ProfileImageVM>().setImage(
        File(image.path),
      );
    }
  }

  Future<void> saveProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profileImage", path);
  }
  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();

    String? imagePath = prefs.getString("profileImage");

    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              children: [

                const Center(
                  child: Text(
                    "Choose Profile Photo",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(Icons.camera_alt,
                      color: AppColors.primary),
                  title: const Text("Camera"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.photo,
                      color: AppColors.primary),
                  title: const Text("Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),

              ],
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.fromOtp,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          automaticallyImplyLeading: !widget.fromOtp,
          iconTheme: const IconThemeData(
            color: AppColors.background,
          ),
          elevation: 0,
          backgroundColor: AppColors.primary,
          title: Center(
            child: const Text(
              "Edit Profile",
              style: TextStyle(color: AppColors.background),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Consumer<ProfileImageVM>(
                    builder: (_, imageVM, __) {
                      return CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        backgroundImage: imageVM.image != null
                            ? FileImage(imageVM.image!)
                            : null,
                        child: imageVM.image == null
                            ? const Icon(
                          Icons.person,
                          size: 55,
                          color: Colors.grey,
                        )
                            : null,
                      );
                    },
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _showImagePicker,
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
      
              buildField(
                "Full Name",
                Icons.person,
                nameController,
              ),
      
              const SizedBox(height: 20),
      
              buildField(
                "Email",
                Icons.email,
                emailController,
                readOnly: true,
              ),
      
              const SizedBox(height: 20),
      
              buildField(
                "Phone",
                Icons.phone,
                phoneController,
              ),
      
              const SizedBox(height: 35),
      
              Consumer<EditProfileVM>(
                builder: (context, vm, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: vm.isLoading
                          ? null
                          : () async {
      
                        bool success = await vm.updateProfile(
                          id: widget.id,
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                        );
      
                        if (success) {
      
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(vm.responseModel!.message),
                            ),
                          );
                          if (widget.fromOtp) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Dashboard(),
                              ),
                                  (route) => false,
                            );
                          } else {
                            Navigator.pop(context, true);
                          }
      
                        } else {
      
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Enter 10 digit number "),
                            ),
                          );
      
                        }
      
                      },
                      child: vm.isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(
      String hint,
      IconData icon,
      TextEditingController controller, {
        bool readOnly = false,
      }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,

      keyboardType: hint == "Phone"
          ? TextInputType.number
          : TextInputType.text,

      inputFormatters: hint == "Phone"
          ? [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ]
          : null,

      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}