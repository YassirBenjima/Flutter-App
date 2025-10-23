import 'package:colearn/consts/consts.dart';
import 'package:colearn/consts/lists.dart';
import 'package:colearn/views/auth/login.dart';
import 'package:colearn/views/widgets_common/applogo_widget.dart';
import 'package:colearn/views/widgets_common/bg_widget.dart';
import 'package:colearn/views/widgets_common/custom_textfield.dart';
import 'package:colearn/views/widgets_common/our_button.dart';
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
  
  // Contrôleurs pour les champs de texte
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Méthode pour vérifier si tous les champs sont remplis
  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
           _emailController.text.isNotEmpty &&
           _passwordController.text.isNotEmpty &&
           isCheck == true;
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo CoLearn en bleu clair
              Text(
                "CoLearn",
                style: TextStyle(
                  color: lightBlue,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              40.heightBox,
              
              // Titre principal
              Text(
                "S'inscrire",
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              40.heightBox,
              
              // Champ nom complet
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
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              
              20.heightBox,
              
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
                  onChanged: (value) {
                    setState(() {});
                  },
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
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              
              20.heightBox,
              
              // Checkbox et texte légal
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
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          TextSpan(
                            text: " et la ",
                            style: TextStyle(color: whiteColor, fontSize: 14),
                          ),
                          TextSpan(
                            text: "Notification de confidentialité",
                            style: TextStyle(color: lightBlue, fontSize: 14),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          TextSpan(
                            text: " de CoLearn",
                            style: TextStyle(color: whiteColor, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              40.heightBox,
              
              // Bouton de création de compte
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: _isFormValid ? darkFontGrey : darkFontGrey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: _isFormValid ? () {
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid ? darkFontGrey : darkFontGrey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Créer un compte",
                    style: TextStyle(
                      color: _isFormValid ? whiteColor : whiteColor.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              20.heightBox,
              
              // Bouton de redirection vers login
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Se connecter",
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

