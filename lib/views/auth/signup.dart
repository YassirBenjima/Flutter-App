import 'package:colearn/consts/consts.dart';
import 'package:colearn/consts/lists.dart';
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

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              15.heightBox,
              "Sign up to $appname".text.fontFamily(bold).white.size(25).make(),
              10.heightBox,
              Column(
                children: [
                  customTextField(hint: fullNameHint,title: fullName),
                  10.heightBox,
                  customTextField(hint: emailHint,title: email),
                  10.heightBox,
                  customTextField(hint: passwordHint,title: password),
                  10.heightBox,
                  customTextField(hint: passwordHint,title: retypePassword),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: forgetPassword.text.make(),
                    ),
                  ),
                  10.heightBox,
                  Row(
                    children: [
                      Checkbox(
                        activeColor: golden,
                        checkColor: blackColor,
                        value: isCheck,
                        onChanged: (newValue) {
                          setState(() {
                            isCheck = newValue;
                          });
                        },
                      ),
                      10.widthBox,
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan( text: "I agree to the ", style: TextStyle( fontFamily: regular, color: fontGrey,),),
                            TextSpan( text: termAndCond, style: TextStyle( fontFamily: regular, color: golden,),),
                          ],
                        ),
                      ),
                    ],
                  ),
                  10.heightBox,
                  // ourButton().box.width(context.screenWidth - 50).make(),
                  ourButton(color: blackColor,title: signup,textColor: whiteColor,onPress: (){})
                      .box
                      .width(context.screenWidth - 50)
                      .make(),
                  10.heightBox,
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: alreadyHaveAccount,
                          style: TextStyle(
                            fontFamily: bold,
                            color: fontGrey,
                          ),
                        ),
                        TextSpan(
                          text: login,
                          style: const TextStyle(
                            fontFamily: bold,
                            color: golden,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.back();
                            },
                        ),
                      ],
                    ),
                  ),
                  5.heightBox,
                ],
              ).box.white.rounded.padding(const EdgeInsets.all(16)).width(context.screenWidth - 70).shadowSm.make()
            ],
          ),
        ),
      ),
    );
  }
}

