// ignore_for_file: unnecessary_string_interpolations, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todolist/edit_page.dart';
import 'package:todolist/hexcolor.dart';

import 'single_task_page.dart';

final firestore = FirebaseFirestore.instance;

class SingleTask extends StatelessWidget {
  DocumentSnapshot taskdoc;
  String currentDate;
  BuildContext scafcon;
  SingleTask(this.scafcon, this.currentDate, this.taskdoc, {super.key});

  @override
  Widget build(BuildContext context) {
    DocumentReference docref = firestore
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("Dates")
        .doc(currentDate)
        .collection("Tasks")
        .doc(taskdoc.id);
    bool important = taskdoc["important"];

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
                          .doc(formattedDate(DateTime.now()!))
                          .set({}).then((value) {
                        firestore
                            .collection("Users")
                            .doc(FirebaseAuth.instance.currentUser!.email)
                            .collection("Dates")
                            .doc(formattedDate(DateTime.now()!))
                            .collection("Tasks")
                            .add({
                          "title": taskdoc["title"],
                          "description": taskdoc["description"],
                          "due": taskdoc["due"].toDate(),
                          "finished": true,
                          "important": taskdoc["important"]
                        });
                        docref.delete();
                      });
                    },
                    child: SizedBox(
                      width: 35,
                      child: Image.asset("assets/chekk_circle.png"),
                    )),
                SizedBox(
                  width: 20,
                ),
                Expanded(flex: 5, child: Text(taskdoc["title"])),
                Expanded(flex: 1, child: Container()),
                GestureDetector(
                  onTap: () {
                    docref.update({"important": !important});
                    ScaffoldMessenger.of(scafcon).showSnackBar(const SnackBar(
                      content: Text("Task Updated!"),
                      duration: Duration(milliseconds: 300),
                    ));
                  },
                  child: Icon(
                    !important ? Icons.star_outline : Icons.star,
                    color: Colors.yellow,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: SectionTitlesTemplate("Delete Task?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel")),
                              TextButton(
                                  onPressed: () async {
                                    await docref.delete();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Task Deleted Successfully!")));
                                    Navigator.pop(context);
                                  },
                                  child: Text("Confirm"))
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.delete_rounded,
                      color: Colors.white,
                    )),
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
                          "${DateFormat(DateFormat.YEAR_MONTH_DAY).format(taskdoc["due"].toDate())} - ${DateFormat(DateFormat.HOUR_MINUTE).format(taskdoc["due"].toDate())}"),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  SingleTaskPage(taskdoc, docref),
                            ));
                          },
                          child: Text("More Details"))
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
    DocumentReference docref = firestore
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("Dates")
        .doc(currentDate)
        .collection("Tasks")
        .doc(taskdoc.id);
    bool important = taskdoc["important"];
    return Card(
      color: Colors.white,
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
                            "${DateFormat(DateFormat.YEAR_MONTH_DAY).format(taskdoc["due"].toDate())} - ${DateFormat(DateFormat.HOUR_MINUTE).format(taskdoc["due"].toDate())}"),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    SingleTaskPage(taskdoc, docref),
                              ));
                            },
                            child: Text("More Details"))
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
                          docref.update({"finished": false});
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
                    Expanded(
                      flex: 5,
                      child: Text(
                        taskdoc["title"],
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Container()),
                    GestureDetector(
                      onTap: () {
                        docref.update({"important": !important});
                        ScaffoldMessenger.of(scafcon)
                            .showSnackBar(const SnackBar(
                          content: Text("Task Updated!"),
                          duration: Duration(milliseconds: 300),
                        ));
                      },
                      child: Icon(
                        !important ? Icons.star_outline : Icons.star,
                        color: Colors.yellow,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(10)),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: SectionTitlesTemplate("Delete Task?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel")),
                                  TextButton(
                                      onPressed: () async {
                                        await docref.delete();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Task Deleted Successfully!")));
                                        Navigator.pop(context);
                                      },
                                      child: Text("Confirm"))
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                        )),
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
