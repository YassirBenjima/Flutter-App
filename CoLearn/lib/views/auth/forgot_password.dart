import 'package:colearn/consts/consts.dart';
import 'package:colearn/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:colearn/views/auth/verify_code.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez saisir votre e-mail"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ApiService.requestPasswordReset(email: email);
      Get.to(() => VerifyCodeScreen(email: email));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(),
        iconTheme: const IconThemeData(color: whiteColor),
        elevation: 0,
      ),
      backgroundColor: blackColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.heightBox,
              "Entrez votre adresse e-mail pour recevoir un lien de réinitialisation."
                  .text
                  .color(whiteColor)
                  .size(16)
                  .make(),
              20.heightBox,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: whiteColor, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _emailController,
                  style: const TextStyle(color: whiteColor),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Adresse e-mail",
                    hintStyle: TextStyle(color: fontGrey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              30.heightBox,
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSubmitting ? darkFontGrey.withOpacity(0.5) : lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
                          ),
                        )
                      : "Envoyer le lien".text.color(whiteColor).fontWeight(FontWeight.bold).size(16).make(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


