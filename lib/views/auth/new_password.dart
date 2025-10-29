import 'package:colearn/consts/consts.dart';
import 'package:colearn/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:colearn/views/auth/login.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;
  final String code;
  const NewPasswordScreen({super.key, required this.email, required this.code});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submit() async {
    final p1 = _pwdController.text;
    final p2 = _confirmController.text;
    if (p1.isEmpty || p2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez remplir tous les champs'), backgroundColor: Colors.red));
      return;
    }
    if (p1 != p2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Les mots de passe ne correspondent pas'), backgroundColor: Colors.red));
      return;
    }
    setState(() { _isSubmitting = true; });
    try {
      await ApiService.confirmResetPassword(email: widget.email, code: widget.code, newPassword: p1);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Mot de passe mis à jour'), backgroundColor: lightBlue));
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() { _isSubmitting = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SizedBox.shrink(), iconTheme: const IconThemeData(color: whiteColor), elevation: 0),
      backgroundColor: blackColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.heightBox,
              'Nouveau mot de passe'.text.color(whiteColor).make(),
              20.heightBox,
              Container(
                decoration: BoxDecoration(border: Border.all(color: whiteColor, width: 1), borderRadius: BorderRadius.circular(8)),
                child: TextField(
                  controller: _pwdController,
                  obscureText: true,
                  style: const TextStyle(color: whiteColor),
                  decoration: InputDecoration(hintText: 'Nouveau mot de passe', hintStyle: TextStyle(color: fontGrey), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
                ),
              ),
              12.heightBox,
              Container(
                decoration: BoxDecoration(border: Border.all(color: whiteColor, width: 1), borderRadius: BorderRadius.circular(8)),
                child: TextField(
                  controller: _confirmController,
                  obscureText: true,
                  style: const TextStyle(color: whiteColor),
                  decoration: InputDecoration(hintText: 'Confirmer le mot de passe', hintStyle: TextStyle(color: fontGrey), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
                ),
              ),
              20.heightBox,
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: _isSubmitting ? darkFontGrey.withOpacity(0.5) : lightBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: _isSubmitting
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(whiteColor)))
                      : 'Enregistrer'.text.color(whiteColor).fontWeight(FontWeight.bold).size(16).make(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


