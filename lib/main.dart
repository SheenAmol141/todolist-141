import 'dart:html';

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

// ...

final firestore = FirebaseFirestore.instance;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // debugPaintSizeEnabled = true;

  final prefs = await SharedPreferences.getInstance();
  final firstOpen = prefs.getBool("opened") ?? false;

  runApp(MaterialApp(theme: theme(), home: SplashScreen(firstOpen)));
}

ThemeData theme() {
  //all app theme
  return ThemeData(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: CHEKK_GREEN,
          extendedTextStyle: GoogleFonts.redHatDisplay(
              color: Colors.white, fontWeight: FontWeight.w500)),
      appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.transparent,
          backgroundColor: CHEKK_GREEN,
          titleTextStyle: GoogleFonts.redHatDisplay(color: Colors.white)),
      // textTheme: GoogleFonts.redHatDisplayTextTheme(),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            side: MaterialStatePropertyAll(
              BorderSide(
                color: Colors.transparent,
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(24),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(CHEKK_GREEN),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            textStyle: MaterialStatePropertyAll(GoogleFonts.redHatDisplay(
                color: Colors.red, fontWeight: FontWeight.w500, fontSize: 20))),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(CHEKK_GREEN),
              textStyle: MaterialStatePropertyAll(TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)))),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CHEKK_GREEN, width: 3.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ));
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //initial variables
  bool loggedin = false;
  String email = '';
  final emailauthprov = EmailAuthProvider();
  final searchcontroller = TextEditingController();
  bool searching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> dates = [];
    return loggedin
        ? Scaffold(
            floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddTaskPage(context),
                  ));
                },
                label: Text(
                  "Add a Task",
                  style: TextStyle(color: Colors.white),
                )),
            appBar: AppBar(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 40,
                      child: Image.asset("assets/chekk_white_variant.png")),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextFormField(
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Entered"),
                              duration: Duration(milliseconds: 500),
                            ));
                          },
                          controller: searchcontroller,
                          decoration: InputDecoration(
                              alignLabelWithHint: false,
                              icon: Icon(Icons.search_rounded),
                              iconColor: Colors.white,
                              label: Text("Search for a Task"),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15)),
                        )),
                  )
                ],
              ),
            ),
            body: Stack(
              children: [
                Container(
                  color: CHEKK_GREEN,
                ),
                CardTemplate(
                  child: SingleChildScrollView(
                    child: Container(
                      color: CupertinoColors.lightBackgroundGray,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          SectionTitlesTemplate("All Tasks"),
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
                                    padding: const EdgeInsets.all(20.0),
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final currentdate = dates[index];
                                          return Column(
                                            children: [
                                              StreamBuilder(
                                                stream: firestore
                                                    .collection("Users")
                                                    .doc(email)
                                                    .collection("Dates")
                                                    .doc(currentdate)
                                                    .collection("Tasks")
                                                    .where("finished",
                                                        isEqualTo: false)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: Container(),
                                                    );
                                                  } else if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: CHEKK_GREEN,
                                                      ),
                                                    );
                                                  } else {
                                                    List<DocumentSnapshot>
                                                        tasks = [];
                                                    for (DocumentSnapshot task
                                                        in snapshot
                                                            .data!.docs.reversed
                                                            .toList()) {
                                                      if (searching) {
                                                        if (task["title"]
                                                            .toString()
                                                            .toLowerCase()
                                                            .startsWith(
                                                                searchcontroller
                                                                    .text))
                                                          tasks.add(task);
                                                      } else {
                                                        tasks.add(task);
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
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5.0),
                                                          child: Text(
                                                            "Due on " +
                                                                currentdate,
                                                            style: GoogleFonts
                                                                .redHatDisplay(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        ListView.separated(
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              final currenttask =
                                                                  tasks[index];

                                                              return SingleTask(
                                                                  context,
                                                                  currentdate,
                                                                  currenttask);
                                                            },
                                                            separatorBuilder:
                                                                (context,
                                                                        index) =>
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                            itemCount:
                                                                tasks.length),
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
                                        separatorBuilder: (context, index) =>
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
                                for (DocumentSnapshot date
                                    in snapshot.data!.docs.reversed.toList()) {
                                  dates.add(date.id);
                                }
                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final currentdate = dates[index];
                                          return Column(
                                            children: [
                                              StreamBuilder(
                                                stream: firestore
                                                    .collection("Users")
                                                    .doc(email)
                                                    .collection("Dates")
                                                    .doc(currentdate)
                                                    .collection("Tasks")
                                                    .where("finished",
                                                        isEqualTo: true)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: Text("noData"),
                                                    );
                                                  } else if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: CHEKK_GREEN,
                                                      ),
                                                    );
                                                  } else {
                                                    List<DocumentSnapshot>
                                                        tasks = [];
                                                    for (DocumentSnapshot task
                                                        in snapshot
                                                            .data!.docs.reversed
                                                            .toList()) {
                                                      if (searching) {
                                                        if (task["title"]
                                                            .toString()
                                                            .toLowerCase()
                                                            .startsWith(
                                                                searchcontroller
                                                                    .text))
                                                          tasks.add(task);
                                                      } else {
                                                        tasks.add(task);
                                                      }
                                                    }
                                                    if (tasks.isEmpty)
                                                      return Container();
                                                    return ListView.separated(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
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
                                                            tasks.length);
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
              ],
            ))
        : Scaffold(
            //login screen
            body: Stack(
            children: [
              FittedVideo(),
              Container(color: CHEKK_GREEN.withOpacity(.6)),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),
                    SizedBox(
                      width: 300,
                      child: Image.asset("assets/chekk_white_variant.png"),
                    ),
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CardTemplate(
                          child: SignInScreen(providers: [
                            EmailAuthProvider(),
                          ], actions: [
                            AuthStateChangeAction<UserCreated>(
                                (context, state) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Account created successfully"),
                                      duration: Duration(milliseconds: 500)));
                              firestore
                                  .collection("Users")
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .set({});
                              isLoggedIn();
                            }),
                            AuthStateChangeAction<SignedIn>((context, state) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Signed In"),
                                      duration: Duration(milliseconds: 500)));
                              isLoggedIn();
                            })
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
  }

// functions
  isLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        loggedin = true;
        email = FirebaseAuth.instance.currentUser!.email!;
      });
    }
  }
}