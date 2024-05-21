import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todolist/hexcolor.dart';
import 'package:todolist/main.dart';
import 'package:todolist/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  bool firstOpen;
  SplashScreen(this.firstOpen, {super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => !firstOpen ? OnboardingScreen() : MainScreen(),
      ));
    });
    return Scaffold(
        backgroundColor: CHEKK_GREEN,
        body: Center(
          child: SizedBox(
              height: 300, child: Image.asset("assets/check_alt_white.png")),
        ));
  }
}
