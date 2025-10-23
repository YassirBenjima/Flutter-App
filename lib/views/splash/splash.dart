import 'package:colearn/consts/consts.dart';
import 'package:colearn/views/auth/login.dart';
import 'package:colearn/views/widgets_common/applogo_widget.dart';
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
      Get.to(() => const LoginScreen());
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
        backgroundColor: lightBlue, // Light blue background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App name in bold black text
            Text(
              appname.toString(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 20),
            // Custom animated spinner
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

