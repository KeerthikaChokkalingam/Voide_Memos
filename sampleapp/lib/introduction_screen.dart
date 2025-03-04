import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:sampleapp/new_recording_screen.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double firstImageWidth = screenWidth * 0.45;
    final double firstImageHeight = firstImageWidth * (202 / 197);
    final double secondImageWidth = screenWidth * 0.8;
    final double secondImageHeight = secondImageWidth * (320 / 320);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFAD5B2),
              Color(0xFFFAD5B2),
              Color(0xFFEADEC6),
              Color(0xFFC3F2F9),
              Color(0xFFC5F0F6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
              child: Stack(
                children: [
                  Positioned(
                    left: screenWidth * 0.02,
                    top: screenHeight * 0.45 - (firstImageHeight / 2),
                    child: Image.asset(
                      'assets/images/Books-And-Headset.png',
                      width: firstImageWidth,
                      height: firstImageHeight,
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.03 + (firstImageWidth * 0.25),
                    top: screenHeight * 0.45 - (secondImageHeight / 1.9),
                    child: Image.asset(
                      'assets/images/Shapes-Design.png',
                      width: secondImageWidth,
                      height: secondImageHeight,
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.5 + (secondImageHeight / 2) - 30,
                    left: screenWidth * 0.1,
                    right: screenWidth * 0.1,
                    child: const Text(
                      "Speed your \n learning process ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF7B88E0),
                          fontSize: 31,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.57 + (secondImageHeight / 2) + 20,
                    left: screenWidth * 0.1,
                    right: screenWidth * 0.1,
                    child: const Text(
                      "Share your essays with your teacher",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF7B88E0),
                          fontSize: 16,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.6 + (secondImageHeight / 2) + 80,
                    left: screenWidth * 0.1,
                    right: screenWidth * 0.1,
                    child: Bounceable(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewRecordingScreen()));
                      }, child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35.0),
                        color: const Color(0xFF5D5FEF),
                      ),
                      child: const Center(
                        child: Text(
                          "Getting Started",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    )
                  ),
                ],
              ),
            ),
    );
  }
}
