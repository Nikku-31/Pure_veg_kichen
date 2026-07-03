import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/Screen/edit_profile.dart';
import 'package:pure_veg/Widget/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppManager/ViewModel/AccountVM/otp_vm.dart';

class Otp extends StatefulWidget {
  final String email;
  const Otp({super.key,
    required this.email,
  });

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  int secondsRemaining = 120;
  Timer? timer;
  bool otpCompleted = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodes[0].requestFocus();
    });
    startTimer();
  }
  final List<TextEditingController> controllers =
  List.generate(6, (index) => TextEditingController());

  final List<FocusNode> focusNodes =
  List.generate(6, (index) => FocusNode());
  void startTimer() {
    timer?.cancel();

    secondsRemaining = 120;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Widget otpBox(int index) {
    return SizedBox(
      width: 48,
      height: 60,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        autofocus: index == 0,
        keyboardType: TextInputType.number,
        showCursor: true,
        cursorColor: const Color(0xff2D6773),
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: const Color(0xffF4F4F4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xff2D6773),
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            } else {
              // Last box fill hone par keyboard hide
              FocusScope.of(context).unfocus();
            }
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(focusNodes[index - 1]);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     onPressed: () => Navigator.pop(context),
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       color: Colors.black,
      //     ),
      //   ),
      // ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: ((didPop, result) {
          if (didPop) return;
          
          showDialog(context: context,
              barrierDismissible: false,
              builder: (context)=> AlertDialog(
                title:  Text("OTP Verification"),
                content: const Text("Please fill OTP."),
                actions: [

                  TextButton(

                      onPressed: (){
                        Navigator.pop(context);},
                      child:Text("OK"),)
                ],
              )
          );
        }),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
        
                  /// OTP Image
                  Image.asset(
                    "assets/image/otp.png",
                    height: 180,
                  ),
        
                  const SizedBox(height: 35),
        
                  const Text(
                    "OTP Verification",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        
                  const SizedBox(height: 10),
        
                  Text(
                    "Enter the OTP sent to ${widget.email}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
        
                  const SizedBox(height: 30),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                          (index) => otpBox(index),
                    ),
                  ),
        
                  const SizedBox(height: 25),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive the OTP? ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      secondsRemaining == 0
                          ? GestureDetector(
                        onTap: () {
                          // Yahan Resend OTP API call karna
                          startTimer();
                        },
                        child: const Text(
                          "Resend OTP",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff2D6773),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                          : Text(
                        "Resend in ${Duration(seconds: secondsRemaining).toString().substring(2, 7)}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
        
                  const SizedBox(height: 35),
        
                  Consumer<OtpVM>(
                    builder: (context, vm, child) {
                      return SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: vm.isLoading
                              ? null
                              : () async {
                            String otp = controllers
                                .map((e) => e.text)
                                .join();
        
                            if (otp.length != 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter valid OTP"),
                                ),
                              );
                              return;
                            }
        
                            bool success = await vm.verifyOtp(
                              email: widget.email,
                              otp: otp,
                            );
        
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(vm.responseModel?.message ?? ""),
                              ),
                            );
        
                            if (success) {
                              final prefs = await SharedPreferences.getInstance();
        
                              // Login Status Save
                              await prefs.setBool("isLogin", true);
        
                              // User Data Save
                              await prefs.setInt(
                                "userId",
                                vm.responseModel?.user?.id ?? 0,
                              );
        
                              await prefs.setString(
                                "userEmail",
                                vm.responseModel?.user?.email ?? "",
                              );
                              await prefs.setString(
                                "userName",
                                vm.responseModel?.user?.name ?? "",
                              );
        
                              await prefs.setString(
                                "userPhone",
                                vm.responseModel?.user?.phone ?? "",
                              );
                              final user = vm.responseModel!.user!;
        
                              if ((user.name).trim().isEmpty || (user.phone).trim().isEmpty) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditProfile(
                                      id: user.id,
                                      name: user.name,
                                      email: user.email,
                                      phone: user.phone,
                                      fromOtp: true,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const Profile(),
                                  ),
                                      (route) => false,
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2D6773),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: vm.isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : const Text(
                            "Verify & Proceed",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
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
        ),
      ),
    );
  }
}