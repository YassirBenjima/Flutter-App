import 'package:boutika/consts/consts.dart';
import 'package:boutika/views/widgets_common/applogo_widget.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              blackColor,
              blackColor,
              darkFontGrey,
              blackColor,
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: applogoWidget(),
              ),
              
              40.heightBox,
              
              // App name
              appname.text
                  .fontFamily(bold)
                  .size(28)
                  .color(whiteColor)
                  .letterSpacing(1.2)
                  .make(),
              
              10.heightBox,
              
              // Decorative line
              Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              15.heightBox,
              
              // App version
              appversion.text
                  .color(whiteColor.withOpacity(0.8))
                  .size(14)
                  .make(),
            ],
          ),
        ),
      ),
    );
  }
}
