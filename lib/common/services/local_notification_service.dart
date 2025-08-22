import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) async {
    Future onDidReceiveLocalNotification(
        int id, String? title, String? body, String? payload) async {
      if (title != null) {
        context.pushNamed('notification');
      }
    }

    void onDidReceiveNotificationResponse(
        {required NotificationResponse notificationResponse, onData}) async {
      if (notificationResponse.payload != null) {
        context.pushNamed('notification');
      }
    }

    InitializationSettings initializationSettings = InitializationSettings(
        android: const AndroidInitializationSettings("@mipmap/ic_notification"),
        iOS: DarwinInitializationSettings(
            // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
            ));

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) {
        onDidReceiveNotificationResponse(
            notificationResponse: notificationResponse,
            onData: () {
              context.pushNamed('notification');
            });
      },
    );
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String? longdata = message.notification?.body;
      BigTextStyleInformation bigTextStyleInformation =
          BigTextStyleInformation(longdata ?? '');

      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "piiink",
          "piiink",
          channelDescription: "This is Piiink Member App",
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigTextStyleInformation,
          onlyAlertOnce: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          presentBanner: true,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data["route"],
      );
    } on Exception {
      // print(e);
    }
  }
}
