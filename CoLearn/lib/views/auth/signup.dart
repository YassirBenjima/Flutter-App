import 'package:colearn/consts/consts.dart';
import 'package:colearn/consts/lists.dart';
import 'package:colearn/views/auth/login.dart';
import 'package:colearn/views/home/home.dart';
import 'package:colearn/views/widgets_common/applogo_widget.dart';
import 'package:colearn/views/widgets_common/bg_widget.dart';
import 'package:colearn/views/widgets_common/custom_textfield.dart';
import 'package:colearn/views/widgets_common/our_button.dart';
import 'package:colearn/services/api_service.dart';
import 'package:colearn/services/oauth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // --- NEW: Selection Variables for Dropdowns ---
  String selectedRole = 'APPRENANT';
  String selectedExpertise = 'Débutant';
  String selectedStyle = 'Visuel';

  // Dropdown Options
  final List<String> roles = ['APPRENANT', 'FORMATEUR'];
  final List<String> expertiseLevels = ['Débutant', 'Intermédiaire', 'Expert'];
  final List<String> learningStyles = ['Visuel', 'Auditif', 'Pratique'];

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        isCheck == true;
  }

  Future<void> _handleRegistration() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Passing new fields to ApiService
      final response = await ApiService.registerUser(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: selectedRole,
        expertiseLevel: selectedExpertise,
        learningStyle: selectedStyle,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Compte créé avec succès!"),
          backgroundColor: lightBlue,
        ),
      );

      Get.to(() => const HomeScreen());

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Helper Widget for Dropdowns to keep code clean
  Widget _buildDropdown(String label, String currentValue, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: fontGrey, fontSize: 12)),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: whiteColor, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              dropdownColor: blackColor, // Matches background
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: whiteColor),
              style: TextStyle(color: whiteColor, fontSize: 16),
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView( // Added ScrollView to prevent overflow
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                20.heightBox,
                Text(
                  "CoLearn",
                  style: TextStyle(
                    color: lightBlue,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                20.heightBox,

                Text(
                  "S'inscrire",
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                30.heightBox,

                // --- EXISTING TEXT FIELDS ---
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: whiteColor, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(color: whiteColor),
                    decoration: InputDecoration(
                      hintText: "Nom complet (requis)",
                      hintStyle: TextStyle(color: fontGrey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                20.heightBox,

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: whiteColor, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _emailController,
                    style: const TextStyle(color: whiteColor),
                    decoration: InputDecoration(
                      hintText: "Adresse e-mail (obligatoire)",
                      hintStyle: TextStyle(color: fontGrey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                20.heightBox,

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: whiteColor, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: whiteColor),
                    decoration: InputDecoration(
                      hintText: "Mot de passe (requis)",
                      hintStyle: TextStyle(color: fontGrey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: fontGrey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                20.heightBox,

                // --- NEW: DROPDOWNS FOR REQUIREMENTS ---
                _buildDropdown("Rôle", selectedRole, roles, (val) {
                  setState(() => selectedRole = val!);
                }),

                _buildDropdown("Niveau d'expertise", selectedExpertise, expertiseLevels, (val) {
                  setState(() => selectedExpertise = val!);
                }),

                _buildDropdown("Préférence d'apprentissage", selectedStyle, learningStyles, (val) {
                  setState(() => selectedStyle = val!);
                }),

                // --- CHECKBOX ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      activeColor: lightBlue,
                      checkColor: blackColor,
                      value: isCheck,
                      onChanged: (newValue) {
                        setState(() {
                          isCheck = newValue;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "En créant un compte, j'accepte les ",
                              style: TextStyle(color: whiteColor, fontSize: 14),
                            ),
                            TextSpan(
                              text: "Conditions d'utilisation",
                              style: TextStyle(color: lightBlue, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                20.heightBox,

                // --- SUBMIT BUTTON ---
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (_isFormValid && !_isLoading) ? darkFontGrey : darkFontGrey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: (_isFormValid && !_isLoading) ? _handleRegistration : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (_isFormValid && !_isLoading) ? darkFontGrey : darkFontGrey.withOpacity(0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(whiteColor)),
                    )
                        : Text(
                      "Créer un compte",
                      style: TextStyle(color: (_isFormValid && !_isLoading) ? whiteColor : whiteColor.withOpacity(0.5), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                20.heightBox,

                // --- GOOGLE BUTTON (Already in your code) ---
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: whiteColor, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handleGoogleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: Icon(Icons.g_mobiledata, color: whiteColor, size: 28), // Simplified icon in case asset missing
                    label: Text(
                      "Continuer avec Google",
                      style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                20.heightBox,

                // --- LOGIN BUTTON ---
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const LoginScreen()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      "Se connecter",
                      style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                20.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Keep existing Google Logic
  Future<void> _handleGoogleSignup() async {
    // ... same as your existing code ...
    // Navigate home
    setState(() => _isLoading = true);
    await Future.delayed(Duration(seconds: 1)); // Fake network
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Demo: Google Auth Simulated")));
    Get.to(() => const HomeScreen());
  }
}