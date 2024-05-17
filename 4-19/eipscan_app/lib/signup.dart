

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eipscan_app/CameraWithRtmp.dart';
import 'package:eipscan_app/SettingScreen.dart';
import 'package:eipscan_app/accountPage.dart';
import 'package:eipscan_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
// ignore: unused_import
import 'Welcome.dart';
import 'information_page.dart';
import 'SettingScreen.dart';
import 'NotificationPage.dart';
import 'onboarding_page_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';



class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String? email;
  String? username;
  String? phone;
  String? password;
  String? confirmPassword;

  final auth = FirebaseAuth.instance;
  bool isEmailValid(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }

  bool isPhoneValid(String phone) {
    Pattern pattern = r'^(010|011|012|015)[0-9]{8}$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(phone);
  }

  bool isNameValid(String name) {
    Pattern pattern = r'^[a-zA-Z]+([\ -][a-zA-Z ])?[a-zA-Z]*$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(name);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    var mediaQuery = MediaQuery;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: const <Widget>[
                    Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create your account",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10.0)
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        username = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'UserName',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.grey.shade800, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.deepOrange.shade800, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        prefixIcon: const Icon(Icons.person,
                            color: Color.fromRGBO(136, 83, 3, 1)),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.grey.shade800, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.deepOrange.shade800, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        prefixIcon: const Icon(Icons.email,
                            color: Color.fromRGBO(136, 83, 3, 1)),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      onChanged: (value) {
                        phone = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Phone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.grey.shade800, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.deepOrange.shade800, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        prefixIcon: const Icon(Icons.phone,
                            color: Color.fromRGBO(136, 83, 3, 1)),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.grey.shade800, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.deepOrange.shade800, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        prefixIcon: const Icon(Icons.lock,
                            color: Color.fromRGBO(136, 83, 3, 1)),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      obscureText: true,
                      onChanged: (value) {
                        confirmPassword = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.grey.shade800, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.deepOrange.shade800, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        prefixIcon: const Icon(Icons.lock,
                            color: Color.fromRGBO(136, 83, 3, 1)),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (username == null ||
                            phone == null ||
                            email == null ||
                            password == null ||
                            confirmPassword == null ||
                            username!.isEmpty ||
                            phone!.isEmpty ||
                            email!.isEmpty ||
                            password!.isEmpty ||
                            confirmPassword!.isEmpty ||
                            !email!.contains('@')) {
                          print("Please enter a valid email and password");
                          return;
                        }
                        if (password != confirmPassword) {
                          print("Passwords do not match");
                          return;
                        }
                        try {
                          var userCredential =
                              await auth.createUserWithEmailAndPassword(
                            email: email!,
                            password: password!,
                          );
                          print("User registered: ${userCredential.user}");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Firstpage()),
                          );
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text(
                        
    "Sign Up",
    style: TextStyle(fontSize: 0.04 * MediaQuery.of(context).size.width, color: Colors.white), 
  ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.03 * MediaQuery.of(context).size.width,
                            horizontal: 0.06 * MediaQuery.of(context).size.width),
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
             
  Padding(
  padding: const EdgeInsets.symmetric(vertical: 15.0),
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(
              fontSize: 10, 
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginForm(),
                ),
              );
            },
            child: Text(
              'Login here',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10, 
              ),
            ),
          ),
        ],
      ),
    ],
  ),
),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
