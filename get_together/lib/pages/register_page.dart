// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_together/components/my_button.dart';
import 'package:get_together/components/my_textfield.dart';
import 'package:get_together/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

  void signUserUp() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    //try creating user
    try {
      //check confirmed password vs password
      if (passwordController.text == confirmedPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      } else {
        //show error message
        invalidInputMessage("Oops! Passwords don't match.");
      }

      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      invalidInputMessage("Oops! Something went wrong.");
    }
  }

  void invalidInputMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              message,
              style: TextStyle(fontSize: 14),
              ),
          ),
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromRGBO(255, 212, 240, 1),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Image.asset(
                './lib/images/LogoNoBG.png',
                width: 400,
                height: 250,
              ),
              Text(
                'Hello there.',
                style: TextStyle(
                  color: Color(0xFF3B3B3B),
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 25),

              //email
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              SizedBox(height: 10),

              //password
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 10),

              //confirm password
              MyTextField(
                controller: confirmedPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
              SizedBox(height: 35),
              MyButton(
                onTap: signUserUp,
                text: "Create Account",
              ),
              SizedBox(height: 50),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
              //   child: Row(
              //     children: [
              //       Expanded(
              //           child: Divider(
              //         thickness: .5,
              //         color: Colors.grey[400],
              //       )),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //         child: Text(
              //           "Or continue with",
              //           style: TextStyle(color: Colors.grey[700]),
              //         ),
              //       ),
              //       Expanded(
              //           child: Divider(
              //         thickness: .5,
              //         color: Colors.grey[400],
              //       )),
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 30,
              // ),
              // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              //   GestureDetector(
              //     onTap: () => AuthService().signInWithGoogle(),
              //     child: Container(
              //       padding: EdgeInsets.all(20),
              //       decoration: BoxDecoration(
              //         border: Border.all(color: Colors.white),
              //         borderRadius: BorderRadius.circular(16),
              //         color: Colors.grey[200],
              //       ),
              //       child: Image.asset(
              //         "./lib/images/google.png",
              //         height: 40,
              //       ),
              //     ),
              //   ),
              //   // const SizedBox(
              //   //   width: 10,
              //   // ),
              //   // Container(
              //   //   padding: EdgeInsets.all(20),
              //   //   decoration: BoxDecoration(
              //   //     border: Border.all(color: Colors.white),
              //   //     borderRadius: BorderRadius.circular(16),
              //   //     color: Colors.grey[200],
              //   //   ),
              //   //   child: Image.asset(
              //   //     "./lib/images/apple.png",
              //   //     height: 40,
              //   //   ),
              //   // ),
              // ]),
              // const SizedBox(
              //   height: 30,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Login here.",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}