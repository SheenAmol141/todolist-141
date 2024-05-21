import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todolist/hexcolor.dart';

final firestore = FirebaseFirestore.instance;

class SingleTask extends StatelessWidget {
  DocumentSnapshot taskdoc;
  String currentDate;
  BuildContext scafcon;
  SingleTask(this.scafcon, this.currentDate, this.taskdoc, {super.key});

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: EdgeInsets.all(7),
          child: ExpansionTile(
            title: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      firestore
                          .collection("Users")
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .collection("Dates")
                          .doc(currentDate)
                          .collection("Tasks")
                          .doc(taskdoc.id)
                          .update({"finished": true});
                      ScaffoldMessenger.of(scafcon).showSnackBar(const SnackBar(
                        content: Text("Task Completed!"),
                        duration: Duration(seconds: 1),
                      ));
                    },
                    child: SizedBox(
                      width: 35,
                      child: Image.asset("assets/chekk_circle.png"),
                    )),
                SizedBox(
                  width: 20,
                ),
                Text(taskdoc["title"])
              ],
            ),
            children: [
              Container(
                color: Colors.grey.withOpacity(.5),
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0, left: 20, right: 20, top: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(taskdoc["description"]),
                      Text(
                          "${DateFormat(DateFormat.HOUR24_MINUTE).format(taskdoc["time-added"].toDate())}"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}

class FinishedSingleTask extends StatelessWidget {
  DocumentSnapshot taskdoc;
  String currentDate;
  BuildContext scafcon;
  FinishedSingleTask(this.scafcon, this.currentDate, this.taskdoc, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(7),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
              children: [
                Container(
                  color: Colors.grey.withOpacity(.5),
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20.0, left: 20, right: 20, top: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(taskdoc["description"]),
                        Text(
                            "${DateFormat(DateFormat.HOUR24_MINUTE).format(taskdoc["time-added"].toDate())}"),
                      ],
                    ),
                  ),
                )
              ],
              title: Opacity(
                opacity: .5,
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          firestore
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .collection("Dates")
                              .doc(currentDate)
                              .collection("Tasks")
                              .doc(taskdoc.id)
                              .update({"finished": false});
                          ScaffoldMessenger.of(scafcon).showSnackBar(
                              const SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text("Task set as Incomplete!")));
                        },
                        child: SizedBox(
                          width: 35,
                          child: Image.asset("assets/chekk_logo_green.png"),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      taskdoc["title"],
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
    ;
  }
}

class SingleDate {
  String date;
  List<DocumentSnapshot> tasks = [];
  SingleDate(this.tasks, this.date);

  List<DocumentSnapshot> get dateTasks => tasks;
  String get dateName => date;
}

class SectionTitlesTemplate extends StatelessWidget {
  String text;
  SectionTitlesTemplate(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(fontSize: 25, fontWeight: FontWeight.w600),
    );
  }
}

class SectionTitlesTemplateWhite extends StatelessWidget {
  String text;
  SectionTitlesTemplateWhite(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
          fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
    );
  }
}

class CardTemplate extends StatelessWidget {
  Widget child;
  CardTemplate({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.white,
      child: child,
    );
  }
}