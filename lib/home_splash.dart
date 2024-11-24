import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mazdoor/user_data.dart';

class HomeSplash extends StatefulWidget {
  const HomeSplash({super.key});

  @override
  _HomeSplashState createState() => _HomeSplashState();
}

class _HomeSplashState extends State<HomeSplash> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserDetailsFormScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/1.png',
            width: screenWidth * 0.7, // Increased the width
            height: screenHeight * 0.4, // Increased the height
            fit: BoxFit.contain,
          ),
          Text(
            'Setting up things for you',
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
        ],
      ),
    ));
  }
}
