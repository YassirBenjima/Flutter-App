import 'package:colearn/consts/consts.dart';
import 'package:flutter/material.dart';

Widget applogoWidget(){
    return Container(
      width: 125,
      height: 125,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            lightGrey,
            lightGrey,
            lightGrey,
          ],
        ),
        borderRadius: BorderRadius.circular(62.5),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Image.asset(
        icAppLogo,
        colorBlendMode: BlendMode.overlay,
      ),
    );
}