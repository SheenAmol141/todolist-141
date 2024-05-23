import 'package:flutter/material.dart';
import 'package:todolist/hexcolor.dart';
import 'package:todolist/templates.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> dev = [
      "Sheen Joshua Amol",
      "Lance Kear Victorio",
      "Mark Lyndon Manuel",
      "Marc Angelo Lopez",
      "Elijah Gabriel Tabora",
    ];
    List<String> images = [
      "sheen.jpg",
      "lance.jpg",
      "lyndon.jpg",
      "marc.jpg",
      "gab.jpg"
    ];
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          SectionTitlesTemplate("Meet The Developers"),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: dev.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: !(index == dev.length - 1) ? 0 : 20),
                child: CardTemplate(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Wrap(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            AssetImage("${"assets/"}${images[index]}"),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: [
                          Text(
                            dev[index],
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 5,
            ),
          ),
        ],
      ),
    );
  }
}
