import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/add_task_page.dart';
import 'package:todolist/fitvid.dart';
import 'package:todolist/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todolist/splash_screen.dart';
import 'package:todolist/templates.dart';
import 'firebase_options.dart';

class SearchPage extends StatefulWidget {
  String email;
  SearchPage(this.email, {super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool loggedin = false;
  String email = '';
  final emailauthprov = EmailAuthProvider();
  final searchcontroller = TextEditingController();
  bool searching = false;
  bool importantonly = false;

  @override
  Widget build(BuildContext context) {
    email = widget.email;
    return Scaffold(
        appBar: AppBar(
          title: Text("Search"),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Stack(
          children: [
            Container(
              color: CHEKK_GREEN,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 4),
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (value) {
                              if (searchcontroller.text == null ||
                                  searchcontroller.text.length == 0) {
                                setState(() {
                                  searching = false;
                                });
                              }
                            },
                            onEditingComplete: () {
                              setState(() {
                                if (searchcontroller.text == null ||
                                    searchcontroller.text.length == 0) {
                                  searching = false;
                                } else {
                                  searching = true;
                                }
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Entered"),
                                duration: Duration(milliseconds: 500),
                              ));
                            },
                            controller: searchcontroller,
                            decoration: InputDecoration(
                                alignLabelWithHint: false,
                                icon: Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                ),
                                label: Text("Search for a Task"),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Show Important Only',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Switch(
                                value: importantonly,
                                onChanged: (value) {
                                  setState(() {
                                    searching = true;
                                    importantonly = value;
                                    if (!value &&
                                        searchcontroller.text.isEmpty) {
                                      searching = false;
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 4,
                ),
                searching
                    ? Expanded(
                        child: CardTemplate(
                          child: Container(
                            color: CupertinoColors.lightBackgroundGray,
                            child: SingleChildScrollView(
                              child: Container(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 40,
                                    ),
                                    SectionTitlesTemplate("Current Tasks"),
                                    StreamBuilder(
                                      stream: firestore
                                          .collection("Users")
                                          .doc(email)
                                          .collection("Dates")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: Container(),
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: CHEKK_GREEN,
                                            ),
                                          );
                                        } else {
                                          List<String> dates = [];
                                          for (DocumentSnapshot date
                                              in snapshot.data!.docs.toList()) {
                                            dates.add(date.id);
                                          }
                                          return SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: ListView.separated(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final currentdate =
                                                        dates[index];
                                                    return Column(
                                                      children: [
                                                        StreamBuilder(
                                                          stream: firestore
                                                              .collection(
                                                                  "Users")
                                                              .doc(email)
                                                              .collection(
                                                                  "Dates")
                                                              .doc(currentdate)
                                                              .collection(
                                                                  "Tasks")
                                                              .where("finished",
                                                                  isEqualTo:
                                                                      false)
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (!snapshot
                                                                .hasData) {
                                                              return Center(
                                                                child:
                                                                    Container(),
                                                              );
                                                            } else if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color:
                                                                      CHEKK_GREEN,
                                                                ),
                                                              );
                                                            } else {
                                                              List<DocumentSnapshot>
                                                                  tasks = [];
                                                              for (DocumentSnapshot task
                                                                  in snapshot
                                                                      .data!
                                                                      .docs
                                                                      .reversed
                                                                      .toList()) {
                                                                if (searching) {
                                                                  if (importantonly &&
                                                                      searchcontroller
                                                                          .text
                                                                          .isEmpty) {
                                                                    if (task[
                                                                        "important"]) {
                                                                      tasks.add(
                                                                          task);
                                                                    }
                                                                  } else if (importantonly &&
                                                                      searchcontroller
                                                                          .text
                                                                          .isNotEmpty) {
                                                                    if (task["title"]
                                                                            .toString()
                                                                            .toLowerCase()
                                                                            .startsWith(searchcontroller
                                                                                .text) &&
                                                                        task[
                                                                            "important"]) {
                                                                      tasks.add(
                                                                          task);
                                                                    }
                                                                  } else if (!importantonly &&
                                                                      searchcontroller
                                                                          .text
                                                                          .isNotEmpty) {
                                                                    if (task[
                                                                            "title"]
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .startsWith(
                                                                            searchcontroller.text)) {
                                                                      tasks.add(
                                                                          task);
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                              if (tasks.isEmpty)
                                                                return Container();
                                                              return Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            5.0),
                                                                    child: Text(
                                                                      "Due on " +
                                                                          currentdate,
                                                                      style: GoogleFonts
                                                                          .redHatDisplay(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  ListView.separated(
                                                                      shrinkWrap: true,
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      itemBuilder: (context, index) {
                                                                        final currenttask =
                                                                            tasks[index];

                                                                        return SingleTask(
                                                                            context,
                                                                            currentdate,
                                                                            currenttask);
                                                                      },
                                                                      separatorBuilder: (context, index) => SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                      itemCount: tasks.length),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              );
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                  itemCount: dates.length),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    SectionTitlesTemplate("Finished Tasks"),
                                    StreamBuilder(
                                      stream: firestore
                                          .collection("Users")
                                          .doc(email)
                                          .collection("Dates")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: Text("noData"),
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: CHEKK_GREEN,
                                            ),
                                          );
                                        } else {
                                          List<String> dates = [];
                                          for (DocumentSnapshot date in snapshot
                                              .data!.docs.reversed
                                              .toList()) {
                                            dates.add(date.id);
                                          }
                                          return SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final currentdate =
                                                        dates[index];
                                                    return Column(
                                                      children: [
                                                        StreamBuilder(
                                                          stream: firestore
                                                              .collection(
                                                                  "Users")
                                                              .doc(email)
                                                              .collection(
                                                                  "Dates")
                                                              .doc(currentdate)
                                                              .collection(
                                                                  "Tasks")
                                                              .where("finished",
                                                                  isEqualTo:
                                                                      true)
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (!snapshot
                                                                .hasData) {
                                                              return Center(
                                                                child: Text(
                                                                    "noData"),
                                                              );
                                                            } else if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color:
                                                                      CHEKK_GREEN,
                                                                ),
                                                              );
                                                            } else {
                                                              List<DocumentSnapshot>
                                                                  tasks = [];
                                                              for (DocumentSnapshot task
                                                                  in snapshot
                                                                      .data!
                                                                      .docs
                                                                      .reversed
                                                                      .toList()) {
                                                                if (searching) {
                                                                  if (importantonly &&
                                                                      searchcontroller
                                                                          .text
                                                                          .isEmpty) {
                                                                    if (task[
                                                                        "important"]) {
                                                                      tasks.add(
                                                                          task);
                                                                    }
                                                                  } else if (importantonly &&
                                                                      searchcontroller
                                                                          .text
                                                                          .isNotEmpty) {
                                                                    if (task["title"]
                                                                            .toString()
                                                                            .toLowerCase()
                                                                            .startsWith(searchcontroller
                                                                                .text) &&
                                                                        task[
                                                                            "important"]) {
                                                                      tasks.add(
                                                                          task);
                                                                    }
                                                                  } else if (!importantonly &&
                                                                      searchcontroller
                                                                          .text
                                                                          .isNotEmpty) {
                                                                    if (task[
                                                                            "title"]
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .startsWith(
                                                                            searchcontroller.text)) {
                                                                      tasks.add(
                                                                          task);
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                              if (tasks.isEmpty)
                                                                return Container();
                                                              return ListView
                                                                  .separated(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        final currenttask =
                                                                            tasks[index];

                                                                        return FinishedSingleTask(
                                                                            context,
                                                                            currentdate,
                                                                            currenttask);
                                                                      },
                                                                      separatorBuilder:
                                                                          (context, index) =>
                                                                              SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                      itemCount:
                                                                          tasks
                                                                              .length);
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  },
                                                  itemCount: dates.length),
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: CardTemplate(
                          child: SizedBox(
                            height: double.maxFinite,
                            child: Center(
                              child: Text("Start a Search."),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ));
  }
}
