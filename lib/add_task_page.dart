import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/main.dart';

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
                  StatefulBuilder(
                    builder: (context, setState) => ElevatedButton(
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
                        child: Text(selectedDate != null
                            ? 'Selected Date: ${formattedDate(selectedDate!)}'
                            : 'Select Date')),
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
                              "time-added": DateTime.now(),
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
