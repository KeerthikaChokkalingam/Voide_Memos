import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

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

    // Image dimensions relative to screen size
    final double firstImageWidth = screenWidth * 0.45; // Reduced width slightly
    final double firstImageHeight = firstImageWidth * (202 / 197); // Maintain aspect ratio
    final double secondImageWidth = screenWidth * 0.8; // Slightly reduced
    final double secondImageHeight = secondImageWidth * (320 / 320); // Maintain aspect ratio

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
                    left: screenWidth * 0.02, // 2% padding from left
                    top: screenHeight * 0.45 - (firstImageHeight / 2), // Center Y
                    child: Image.asset(
                      'assets/images/Books-And-Headset.png',
                      width: firstImageWidth,
                      height: firstImageHeight,
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.03 + (firstImageWidth * 0.25), // 90% of first image's width
                    top: screenHeight * 0.45 - (secondImageHeight / 1.9), // Adjusted center
                    child: Image.asset(
                      'assets/images/Shapes-Design.png',
                      width: secondImageWidth,
                      height: secondImageHeight,
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.5 + (secondImageHeight / 2) - 30, // 20px below second image
                    left: screenWidth * 0.1, // 10% from left
                    right: screenWidth * 0.1, // 10% from right
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
                    top: screenHeight * 0.57 + (secondImageHeight / 2) + 20, // 20px below second image
                    left: screenWidth * 0.1, // 10% from left
                    right: screenWidth * 0.1, // 10% from right
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
                    top: screenHeight * 0.6 + (secondImageHeight / 2) + 80, // 20px below second image
                    left: screenWidth * 0.1, // 10% from left
                    right: screenWidth * 0.1, // 10% from right
                    child: Bounceable(
                      onTap: () {

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
                            fontSize: 18, // Responsive font size
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
