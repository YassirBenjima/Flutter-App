import 'package:colearn/consts/consts.dart';
import 'package:colearn/views/auth/signup.dart';
import 'package:colearn/views/home/home.dart';
import 'package:colearn/views/admin/admin_dashboard.dart'; // Import Admin Dashboard
import 'package:colearn/views/widgets_common/applogo_widget.dart';
import 'package:colearn/views/widgets_common/bg_widget.dart';
import 'package:colearn/views/widgets_common/custom_textfield.dart';
import 'package:colearn/views/widgets_common/our_button.dart';
import 'package:colearn/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar("Erreur", "Veuillez remplir tous les champs", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final responseData = await ApiService.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // --- DEBUG PRINT (Check your console to see what role arrives) ---
      print("User Data from Backend: $responseData");

      // --- LOGIC TO CHECK ROLE ---
      String role = responseData['role'] ?? 'APPRENANT'; // Default to Learner if null

      if (role == 'ADMIN') {
        Get.offAll(() => const AdminDashboard()); // Go to Admin Panel
      } else {
        Get.offAll(() => const HomeScreen()); // Go to Normal App
      }

      Get.snackbar("Succès", "Bienvenue ${responseData['fullName']}", backgroundColor: lightBlue, colorText: whiteColor);

    } catch (e) {
      Get.snackbar("Erreur", "Email ou mot de passe incorrect", backgroundColor: Colors.red, colorText: whiteColor);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Text("CoLearn", style: TextStyle(color: lightBlue, fontSize: 32, fontWeight: FontWeight.bold)),
              40.heightBox,

              Text("Connectez-vous à votre compte", style: TextStyle(color: whiteColor, fontSize: 18, fontWeight: FontWeight.bold)),
              40.heightBox,

              // Email Field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: whiteColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              20.heightBox,

              // Password Field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: whiteColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Mot de passe",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),

              10.heightBox,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {}, // Add Forgot Password logic if needed
                    child: const Text("Mot de passe oublié ?", style: TextStyle(color: Colors.blue))
                ),
              ),

              20.heightBox,

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: lightBlue),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Connexion", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),

              20.heightBox,
              const Text("OU", style: TextStyle(color: Colors.grey)),
              20.heightBox,

              // Google Button (Fake)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.g_mobiledata, color: Colors.white),
                      const SizedBox(width: 10),
                      const Text("Continuer avec Google", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),

              20.heightBox,

              // Signup Link
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () => Get.to(() => const SignupScreen()),
                  child: const Text("S'inscrire", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}