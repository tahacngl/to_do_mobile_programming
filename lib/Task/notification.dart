import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:to_do_mobile_programming/task/model/todo.dart';

class NotificationManager {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  initialize() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> showNotification(Todo todo) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your channel id', 'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Tamamlanmamış Görev!',
      'Tamamlanmamış göreviniz var. Görev: ${todo.title}',
      platformChannelSpecifics,
      payload: todo.id.toString(),
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    // Burada bildirime tıklanıldığında yapılacak işlemleri ekleyebilirsiniz.
    // Örneğin, ilgili görevin detay sayfasına yönlendirebilirsiniz.
  }
}

final NotificationManager notificationManager = NotificationManager();
