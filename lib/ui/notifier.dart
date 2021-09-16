import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifier {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static const NotificationDetails platformChannelSpecifics =
      NotificationDetails(
          android: AndroidNotificationDetails('your channel id',
              'your channel name', 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker'));
  setupNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('notification payload: $payload');
      }
    });
  }

  notify(String title,String body) async {
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: 'payload');
  }
}
