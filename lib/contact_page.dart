import 'dart:convert';

import 'package:flutter/material.dart';
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
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        child: Form(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    sendEmail(
                        email: "alpyne141@gmail.com",
                        name: "Alpyne141",
                        subject: "TestingEmail:D",
                        message:
                            "TEST1111111111111111111111111111111111111111111111111111111");
                  },
                  child: Text("Send Test Email")),
            ],
          ),
        ),
      ),
    );
  }

  sendEmail(
      {required String email,
      required String name,
      required String subject,
      required String message}) async {
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
    print(response.body);
  }
}
