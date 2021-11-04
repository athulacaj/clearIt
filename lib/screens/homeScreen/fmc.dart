import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmMain {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late AndroidNotificationChannel channel;

  static void fcmMain() async {
    await Firebase.initializeApp();
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    subscribeToTopic();
  }

  static void subscribeToTopic() async {
    FirebaseMessaging.instance.subscribeToTopic('all');
    getToken();
  }

  static void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  static void onMessageReceived() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        saveData({"title": notification.title, "body": notification.body});
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  icon: 'ic_stat_name',
                  color: Color(0xff7078ff)),
            ));
      }
    });
  }

  // void onMessageOpen(){
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('A new onMessageOpenedApp event was published!');
  //     Navigator.pushNamed(context, '/message',
  //         arguments: MessageArguments(message, true));
  //   });
  // }

  static void saveData(Map messageData) async {
    final localData = await SharedPreferences.getInstance();
    List notificationList = [];
    String? notificationData = localData.getString('notificationList');
    if (notificationData != null) {
      notificationList = jsonDecode(notificationData);
    }
    if (notificationList.length > 20) {
      notificationList.removeAt(0);
    }
    notificationList.add(messageData);
    String data = jsonEncode(notificationList);
    localData.setString('notificationList', data);
    print("saved message data to shared preference");
  }
}
