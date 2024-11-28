import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_to_text_project_fyp/Screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate some loading process
    Timer(Duration(seconds: 5), () {
      // After 3 seconds, navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ImageCaptioningScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace 'assets/logo.png' with your logo image path
            Image.asset(
              'assets/lenguaLens.png',
              width: 200,
              height: 200,
              // You can adjust the width and height according to your logo's dimensions
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

