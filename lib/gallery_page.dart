import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/hexcolor.dart';
import 'package:todolist/templates.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      "chekk_alt_white.png",
      "chekk_alt.png",
      "chekk_circle.png",
      "chekk_green_variant.png",
      "chekk_icon.png",
      "chekk_logo_green.png",
      "chekk_white_variant.png"
    ];
    return SingleChildScrollView(
      child: Column(
        children: [
          SectionTitlesTemplate("Gallery"),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: images.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (_, index) {
                return GridTile(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Image.asset("assets/${images[index]}"),
                          );
                        },
                      );
                    },
                    child: CardTemplate(
                      child: Container(
                        child: Image.asset(
                          "assets/${images[index]}",
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
