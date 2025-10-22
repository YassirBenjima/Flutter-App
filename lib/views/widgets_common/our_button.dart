import 'package:flutter/material.dart';
import 'package:colearn/consts/consts.dart';

Widget ourButton({
  VoidCallback? onPress,
  Color? color,
  Color? textColor,
  required String title,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(12),
      backgroundColor: color,
    ),
    onPressed: onPress,
    child: title.text.color(textColor).fontFamily(bold).make(),
  );
}
