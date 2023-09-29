import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/helper/constans.dart';

class AwesomeNotify {
  static int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  initialize(String shubuh, String sunrise, String dhuhur, String ashar,
      String maghrip, String isya) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            styleInformation: BigTextStyleInformation(''),
            importance: Importance.low,
            priority: Priority.low,
            autoCancel: false,
            color: Color.fromARGB(255, 61, 161, 41),
            icon: 'ic_stat_icon',
            ongoing: true);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    AndroidInitializationSettings('ic_stat_icon');
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin.show(
        0,
        'Namaz Vakitleri',
        'İmsak: $shubuh | Güneş: $sunrise | Öğle:$dhuhur'
            'İkindi: $ashar | Akşam: $maghrip | Yatsı: $isya',
        platformChannelSpecifics,
        payload: 'item x');
  }

  static Future<bool> createBasicNotif({
    String? title,
    String? body,
    required int id,
  }) async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (isAllowed) {
      var illPray = AssetsName.illMuslimPray;
      return await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: "basic_notif",
          title: title,
          body: body,
          wakeUpScreen: true,
          bigPicture: "asset://$illPray",

          notificationLayout: NotificationLayout.BigPicture,
          // fullScreenIntent: true,
          // displayOnBackground: true,
          // displayOnForeground: true,
        ),
      );
    }
    return isAllowed;
  }

  static Future<bool> createScheduleNotif(
      {required int id,
      String? title,
      String? body,
      required DateTime dateTime,
      int? hour,
      int? minute}) async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (isAllowed) {
      var illPray = AssetsName.illMuslimPray;

      dateTime =
          dateTime.subtract(Duration(hours: hour ?? 0, seconds: minute ?? 0));

      log("DateTime After : " + dateTime.toString());

      return await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: "schedule_notif",
          title: title,
          body: body,
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: "asset://$illPray",
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
          criticalAlert: true,
          fullScreenIntent: (minute == 0) ? true : false,
          // displayOnBackground: true,
          // displayOnForeground: true,
        ),
        actionButtons: (minute == 0)
            ? [
                NotificationActionButton(
                  key: "mark_done",
                  label: "Mark Done",
                )
              ]
            : null,
        schedule: NotificationCalendar(
          year: dateTime.year,
          month: dateTime.month,
          day: dateTime.day,
          hour: dateTime.hour,
          minute: dateTime.minute,
          second: 0,
          millisecond: 0,
          repeats: true,
          preciseAlarm: true,
        ),
      );
    }
    return isAllowed;
  }

  static Future<void> cancelScheduledNotificationById(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  static Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }
}
