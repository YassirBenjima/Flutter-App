import 'package:flutter/material.dart';
import 'package:boutika/consts/consts.dart';

Widget ourButton({onPress, color, textColor,title}){
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
          backgroundColor: color
      ),
      onPressed: (){
        onPress;
      },
    child: Text(
      title,
      style: TextStyle(
        color: textColor,
        fontFamily: bold,
      ),
    ),
  );
}