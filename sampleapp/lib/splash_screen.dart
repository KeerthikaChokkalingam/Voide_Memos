import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
                child: Stack(
                  children: [
                    Center(

                    )
                  ],
                ),),
      ),
    );
  }
}
