import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist/hexcolor.dart';
import 'package:todolist/templates.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final namecontroller = TextEditingController();
    final emailcontroller = TextEditingController();
    final subjectcontroller = TextEditingController();
    final messagecontroller = TextEditingController();
    return ListView(children: [
      Container(
        child: Form(
          key: key,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SectionTitlesTemplate("Got any questions? Send us an email."),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: namecontroller,
                  decoration: InputDecoration(label: Text("Name")),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name cannot be empty!";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailcontroller,
                  decoration: InputDecoration(label: Text("Email")),
                  validator: (value) {
                    final emailRegExp = RegExp(
                        r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}$');
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    } else if (!emailRegExp.hasMatch(value)) {
                      return 'Invalid email format';
                    }
                    return null; // No error
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: subjectcontroller,
                  decoration: InputDecoration(label: Text("Subject")),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Subject cannot be empty!";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: messagecontroller,
                  minLines: 3,
                  maxLines: null,
                  decoration: InputDecoration(label: Text("Message")),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Message cannot be empty!";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (key.currentState!.validate()) {
                        sendEmail(
                            email: emailcontroller.text,
                            name: namecontroller.text,
                            subject: subjectcontroller.text,
                            message: messagecontroller.text,
                            context: context);
                      }
                    },
                    child: Text("Send")),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  sendEmail(
      {required String email,
      required String name,
      required String subject,
      required String message,
      required BuildContext context}) async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "service_id": "service_s518hi4",
          "template_id": "template_kggktgm",
          "user_id": "tni6SW6KFZUtzuI-l",
          "template_params": {
            "user_subject": subject,
            "user_message": message,
            "user_name": name,
            "user_email": email
          }
        }));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Your message has been sent successfully!")));
  }
}
