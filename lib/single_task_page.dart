import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/hexcolor.dart';
import 'package:todolist/templates.dart';

class SingleTaskPage extends StatelessWidget {
  DocumentSnapshot taskdoc;
  SingleTaskPage(this.taskdoc, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("More Details about " + taskdoc["title"]),
      ),
      backgroundColor: CHEKK_GREEN,
      body: CardTemplate(
        child: Container(
          width: double.infinity,
          height: double.maxFinite,
          color: CupertinoColors.extraLightBackgroundGray,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                SectionTitlesTemplate(
                  taskdoc["title"],
                ),
                Divider(),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Description:"),
                        Expanded(child: Container())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Container()),
                        Text(taskdoc["description"]),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time Added:"),
                    Expanded(child: Container()),
                    Text(
                        "${DateFormat(DateFormat.YEAR_MONTH_DAY).format(taskdoc["time-added"].toDate())} - ${DateFormat(DateFormat.HOUR_MINUTE).format(taskdoc["time-added"].toDate())}")
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Important:"),
                    Expanded(child: Container()),
                    Text(taskdoc["important"] ? "Yes" : "No")
                  ],
                ),
                Divider(),
                Text(taskdoc["finished"]
                    ? "You have finished this task!"
                    : "You have not yet finished this task")
              ],
            ),
          )),
        ),
      ),
    );
  }
}
