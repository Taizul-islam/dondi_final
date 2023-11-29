import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationAPI{
  static final _notifications=FlutterLocalNotificationsPlugin();
  static DarwinInitializationSettings initializationSettingsDarwin = const DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true,);
  static DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(interruptionLevel: InterruptionLevel.timeSensitive);
  static Future showSimpleNotification({int id=0,String? title,String? body,String? payload})async{
    _notifications.show(id, title, body, await _notificationDetails(),payload: payload);
  }

  static Future _notificationDetails() async{
    return NotificationDetails(
      android: const AndroidNotificationDetails(
        "bubbly",
        "Notification",
        importance: Importance.max
      ),
      iOS: darwinNotificationDetails
    );
  }
  static Future init({bool initScheduled=false})async{
    const android=AndroidInitializationSettings("@mipmap/ic_launcher");
    final setting=InitializationSettings(android: android,iOS: initializationSettingsDarwin);
    await _notifications.initialize(setting,onDidReceiveNotificationResponse: (payload){

    });
  }
  static Future cancelNotification()async{
   await _notifications.cancel(1);
  }

}