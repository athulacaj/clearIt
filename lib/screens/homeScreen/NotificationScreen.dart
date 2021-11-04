import 'dart:convert';

import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  final List notificationList;
  NotificationScreen({required this.notificationList});
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: "Notifications", context: context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: widget.notificationList.length,
          itemBuilder: (BuildContext context, int index) {
            Map data = widget.notificationList.reversed.toList()[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${data['title']}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      Text(
                        "${data['body']}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<List> getNotificationList() async {
  final localData = await SharedPreferences.getInstance();
  List notificationList = [];
  String? notificationData = localData.getString('notificationList');
  if (notificationData != null) {
    notificationList = jsonDecode(notificationData);
  }
  return notificationList;
}

void clearNotificationList() async {
  final localData = await SharedPreferences.getInstance();
  localData.setString('notificationList', jsonEncode([]));
}
