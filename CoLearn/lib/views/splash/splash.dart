import 'package:colearn/consts/consts.dart';
import 'package:colearn/views/auth/login.dart';
// Removed unused applogo import
import 'package:colearn/views/widgets_common/custom_spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // Method to change screen
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      // FIX: Use Get.off() instead of Get.to()
      // This removes the SplashScreen from the back stack so the user cannot return to it.
      Get.off(() => const LoginScreen());
    });
  }

  @override
  void initState() {
    super.initState();
    changeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue, // Ensure this color is defined in consts.dart
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Name
            Text(
              appname, // Removed .toString() as appname is usually already a string
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 20),
            // Custom Spinner
            CustomSpinner(
              size: 30.0,
              color: Colors.grey[600],
              duration: const Duration(milliseconds: 1200),
            ),
          ],
        ),
      ),
    );
  }
}