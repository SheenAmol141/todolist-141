import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todolist/main.dart';
import 'package:todolist/templates.dart' hide firestore;

class AddTaskPage extends StatefulWidget {
  BuildContext scafcon;
  AddTaskPage(this.scafcon, {super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final title = TextEditingController();
    final description = TextEditingController();
    final key = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: CupertinoColors.lightBackgroundGray,
      appBar: AppBar(
        title: Text("Add a Task"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: title,
                    decoration: InputDecoration(label: Text("Task Title")),
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return "This field must not be empty!";
                      } else if (value.length < 3) {
                        return "This field's characters must not be less than 3";
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: description,
                    maxLines: null,
                    minLines: 3,
                    decoration:
                        InputDecoration(label: Text("Task Description")),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StatefulBuilder(
                    builder: (context, setState) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          color: Colors.white,
                          surfaceTintColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              selectedDate != null
                                  ? 'Due Date: ${formattedDate(selectedDate!)}'
                                  : 'Due Date: ',
                              style: GoogleFonts.redHatDisplay(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          alignment: WrapAlignment.spaceAround,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(DateTime.now().year + 5),
                                  );
                                  if (pickedDate != null &&
                                      pickedDate != selectedDate) {
                                    setState(() {
                                      selectedDate = pickedDate;
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_month),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Select Due Date from Calendar'),
                                  ],
                                )),
                            ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    selectedDate = DateTime.now();
                                  });
                                },
                                child: Text('Set Due Date to Today')),
                            ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    selectedDate =
                                        DateTime.now().add(Duration(days: 1));
                                  });
                                },
                                child: Text('Set Due Date to Tomorrow')),
                            ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    selectedDate =
                                        DateTime.now().add(Duration(days: 7));
                                  });
                                },
                                child: Text('Set Due Date to Next Week')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (key.currentState!.validate() &&
                            selectedDate != null) {
                          firestore
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .collection("Dates")
                              .doc(formattedDate(selectedDate!))
                              .set({}).then((value) {
                            firestore
                                .collection("Users")
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .collection("Dates")
                                .doc(formattedDate(selectedDate!))
                                .collection("Tasks")
                                .add({
                              "title": title.text,
                              "description": description.text,
                              "due": selectedDate,
                              "finished": false,
                              "important": false
                            });
                          }).then((value) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(widget.scafcon).showSnackBar(
                                SnackBar(content: Text("Task Added!")));
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Please make sure all fields are valid!")));
                        }
                      },
                      child: Text("Add Task"))
                ],
              )),
        ),
      ),
    );
  }
}

String formattedDate(DateTime date) {
  return DateFormat("MMMM dd, yyyy").format(date);
}
