import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'introduction_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
Timer? timer;

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 3), () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const IntroductionScreen()));
      // Change to your route
    });
  }

  @override
  void dispose(){
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        top: false,
        child: Container(
                  decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xFFFAD5B2),
        Color(0xFFFAD5B2),
        Color(0xFFEADEC6),
        Color(0xFFC3F2F9),
        Color(0xFFC5F0F6),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image(
                  image: AssetImage('assets/images/Shapes-Design.png'),
                  width: 197,
                  height: 202,
                ),
              ),
              SizedBox(height: 40,),
              Text(
                'Sound recording \n  Splash screen',
                style: TextStyle(
                  color: Color(0xFF7B88E0),
                  fontSize: 21,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
