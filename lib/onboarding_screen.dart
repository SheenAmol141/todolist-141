import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/fitvid.dart';
import 'package:todolist/hexcolor.dart';
import 'package:todolist/main.dart';
import 'package:todolist/templates.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FittedVideo(),
          Container(
            color: CHEKK_GREEN.withOpacity(.6),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    child: Image.asset("assets/chekk_white_variant.png"),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "Your Productivity Partner.",
                    style: GoogleFonts.redHatDisplay(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: OutlinedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool("opened", true);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ));
                    },
                    child: Text(
                      "Get Started",
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
