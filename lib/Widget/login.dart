import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Screen/otp.dart';
import 'package:pure_veg/Widget/dashboard.dart';
import 'package:pure_veg/Widget/profile.dart';
import 'package:pure_veg/Widget/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_veg/core/constants/app_colors.dart';

import '../AppManager/ViewModel/AccountVM/login_vm.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}
class _LoginState extends State<Login> {
  bool obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Top Image
            SizedBox(
              height: height * 0.35,
              width: double.infinity,
              child: Image.asset(
                "assets/image/login.png",
                fit: BoxFit.cover,
              ),
            ),
            /// White Card
            Transform.translate(
              offset: Offset(0, -height * 0.02),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.025,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        "Welcome",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: width * 0.09,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Login to your account",
                        style: GoogleFonts.poppins(
                          fontSize: width * 0.04,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 35),
                      /// Email
                      TextFormField(
                        controller: emailController,
                        cursorColor: Colors.black,
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter email";
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,

                          labelText: "Email",
                          labelStyle: GoogleFonts.playfairDisplay(
                            color: Colors.black,
                          ),

                          contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                            vertical: height * 0.018,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      // const SizedBox(height: 20),
                      // /// Password
                      // TextFormField(
                      //
                      //   controller: passwordController,
                      //   obscureText: obscurePassword,
                      //   cursorColor: Colors.black,
                      //   style: GoogleFonts.playfairDisplay(
                      //     color: Colors.black,
                      //     fontSize: 16,
                      //   ),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return "Please enter password";
                      //     }
                      //     return null;
                      //   },
                      //   decoration: InputDecoration(
                      //     filled: true,
                      //     fillColor: Colors.grey.shade100,
                      //
                      //     labelText: "Password",
                      //     labelStyle: GoogleFonts.playfairDisplay(
                      //       color: Colors.black,
                      //     ),
                      //
                      //     contentPadding: EdgeInsets.symmetric(
                      //       horizontal: width * 0.05,
                      //       vertical: height * 0.018,
                      //     ),
                      //
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //     errorBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //     focusedErrorBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot your Email?",
                            style:GoogleFonts.poppins(
                              color: const Color(0xff0D6E63),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      /// Login Button
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.06,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0D6E63),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(width * 0.05),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {

                              final vm = context.read<LoginVM>();

                              bool success = await vm.login(emailController.text.trim());

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(vm.loginResponse?.message ?? ""),
                                ),
                              );

                              if (success) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Otp(
                                       email: emailController.text.trim(),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: width * 0.05,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   "Don't have an account? ",
                          //   style:GoogleFonts.poppins(
                          //     color: Colors.grey.shade500,
                          //     fontSize: width * 0.04,
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Signup(),
                                ),
                              );
                            },
                            child: Text(
                              "Terms and condition",
                              style:GoogleFonts.playfairDisplay(
                                color: const Color(0xff0D6E63),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primary,

                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}