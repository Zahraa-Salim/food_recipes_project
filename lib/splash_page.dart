import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:food_recipes_project/navigation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('../images/fork.png'), // Ensure the path to the image is correct
      title: const Text(
        'Food Recipes App',
        style: TextStyle(
          color: Color(0xFF00796B),
          fontFamily: 'ro',
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xfff6f4fa),
      showLoader: true,
      loaderColor: const Color(0xFF00796B),
      navigator: const Navigation(), // Navigate to BottomNavigation
      durationInSeconds: 1,
    );
  }
}

