import 'package:colearn/consts/consts.dart';
import 'package:flutter/material.dart';

Widget customTextField({String? title, String? hint, controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(blackColor).fontFamily(semibold).size(16).make(),
      5.heightBox,
      TextFormField(
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontFamily: semibold,
            color: textfieldGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: blackColor),
          ),
        ),
      ),
      5.heightBox,
    ],
  );
}
