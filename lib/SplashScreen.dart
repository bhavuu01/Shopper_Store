import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopperstoreuser/Auth/LoginScreen.dart';
import 'package:shopperstoreuser/BottomNavigation/BottomNavigation.dart';

import 'HomePage/HomeScreen.dart';

User? user = FirebaseAuth.instance.currentUser;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), checkingTheSavedData
    );
  }

  void checkingTheSavedData() async {

    // print("user.....${user}");
    if (user == null) {
      // print("object........$user");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      print("user found");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNavigationHome()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.cyan, Colors.redAccent],
          begin: Alignment.topRight,
            end: Alignment.bottomLeft
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('asset/images/shopping.png',height: 200,width: 200,),
            const SizedBox(height: 10,),
            const Text('ShopperStore', style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),

            const SizedBox(height: 20,),

            const CircularProgressIndicator(color: Colors.white,)
          ],
        ),
      ),
    );
  }
}
