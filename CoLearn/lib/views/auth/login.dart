import 'package:colearn/consts/consts.dart';
import 'package:colearn/consts/lists.dart';
import 'package:colearn/views/auth/signup.dart';
import 'package:colearn/views/home/home.dart';
import 'package:colearn/views/widgets_common/applogo_widget.dart';
import 'package:colearn/views/widgets_common/bg_widget.dart';
import 'package:colearn/views/widgets_common/custom_textfield.dart';
import 'package:colearn/views/widgets_common/our_button.dart';
import 'package:colearn/services/api_service.dart';
import 'package:colearn/services/oauth_service.dart';
import 'package:colearn/views/auth/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  
  // Contrôleurs pour les champs de texte
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Méthode pour gérer la connexion
  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veuillez remplir tous les champs"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // Succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connexion réussie!"),
          backgroundColor: lightBlue,
        ),
      );
      
      // Redirection vers la HomePage
      Get.to(() => const HomeScreen());
      
    } catch (e) {
      // Erreur
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo CoLearn en bleu clair
              "CoLearn".text.color(lightBlue).fontWeight(FontWeight.bold).size(32).make(),
              
              40.heightBox,
              
              // Titre principal
              "Connectez-vous à votre compte".text.color(whiteColor).fontWeight(FontWeight.bold).size(24).make(),
              
              40.heightBox,
              
              // Champ email
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
                ),
              ),
              
              20.heightBox,
              
              // Champ mot de passe avec icône œil
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
                ),
              ),
              
              20.heightBox,
              
              // Lien mot de passe oublié
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.to(() => const ForgotPasswordScreen());
                  },
                  child: "Mot de passe oublié ?".text.color(lightBlue).make(),
                ),
              ),
              
              40.heightBox,
              
              // Bouton de connexion
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: _isLoading ? darkFontGrey.withOpacity(0.5) : darkFontGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoading ? darkFontGrey.withOpacity(0.5) : darkFontGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading 
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
                        ),
                      )
                    : "Connexion".text.color(whiteColor).fontWeight(FontWeight.bold).size(16).make(),
                ),
              ),
              
              20.heightBox,
              
              // Séparateur
              Row(
                children: [
                  Expanded(child: Divider(color: fontGrey, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: "OU".text.color(fontGrey).size(14).make(),
                  ),
                  Expanded(child: Divider(color: fontGrey, thickness: 1)),
                ],
              ),
              
              20.heightBox,
              
              // Bouton Google
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: whiteColor, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleGoogleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Image.asset(
                    'assets/icons/google_logo.png',
                    height: 24,
                    width: 24,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.g_mobiledata, color: whiteColor),
                  ),
                  label: "Continuer avec Google".text.color(whiteColor).fontWeight(FontWeight.bold).size(16).make(),
                ),
              ),
              
              20.heightBox,
              
              // Bouton d'inscription
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const SignupScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: "S'inscrire".text.color(whiteColor).fontWeight(FontWeight.bold).size(16).make(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Méthode pour gérer la connexion Google
  Future<void> _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final googleAuth = await OAuthFlutterService.signInWithGoogle();
      if (googleAuth == null) {
        setState(() {
          _isLoading = false;
        });
        return; // User cancelled
      }

      final response = await ApiService.loginWithGoogle(
        idToken: googleAuth['idToken'] as String,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connexion réussie avec Google!"),
          backgroundColor: lightBlue,
        ),
      );
      
      Get.to(() => const HomeScreen());
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur Google: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
}

