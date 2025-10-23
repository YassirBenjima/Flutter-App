import 'package:colearn/consts/consts.dart';
import 'package:colearn/consts/lists.dart';
import 'package:colearn/views/auth/signup.dart';
import 'package:colearn/views/widgets_common/applogo_widget.dart';
import 'package:colearn/views/widgets_common/bg_widget.dart';
import 'package:colearn/views/widgets_common/custom_textfield.dart';
import 'package:colearn/views/widgets_common/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

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
                  onPressed: () {},
                  child: "Mot de passe oublié ?".text.color(lightBlue).make(),
                ),
              ),
              
              40.heightBox,
              
              // Bouton de connexion
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: darkFontGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkFontGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: "Connexion".text.color(whiteColor).fontWeight(FontWeight.bold).size(16).make(),
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
}

