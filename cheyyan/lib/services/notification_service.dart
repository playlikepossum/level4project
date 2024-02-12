import 'package:cheyyan/models/task.dart';
import 'package:cheyyan/ui/notified_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotifyHelper {
  static final NotifyHelper _notificationService = NotifyHelper._internal();
  factory NotifyHelper() {
    return _notificationService;
  }
  NotifyHelper._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  InitializeNotifiaction() async {
    _configureLocalTimeZone();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  displayNotification({required String title, required String body}) async {
    print("doing test");
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!.toInt(),
      task.title,
      task.note,
      _convertTime(task, hour, minutes),
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "${task.title}|" "${task.note}|",
    );
  }

  scheduledWeeklyNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!.toInt(),
      task.title,
      task.note,
      _timeConWeekMonth(task.date, hour, minutes, true, false),
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "${task.title}|" "${task.note}|",
    );
  }

  scheduledMonthlyNotification(int hour, int minutes, Task task) async {
    for (int i = 1; i <= 12; i++) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt() + i,
        task.title,
        task.note,
        _timeConWeekMonth(task.date, hour, minutes, false, true),
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|" "${task.note}|",
      );
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!.toInt(),
      task.title,
      task.note,
      _timeConWeekMonth(task.date, hour, minutes, false, true),
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "${task.title}|" "${task.note}|",
    );
  }

  tz.TZDateTime _timeConWeekMonth(
      String? date, int hour, int minutes, bool isWeekly, bool isMonthly) {
    if (isWeekly) {
      DateTime taskDateTime = DateTime.parse(date!);
      tz.TZDateTime taskTZDateTime = tz.TZDateTime.from(taskDateTime, tz.local);
      tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, taskTZDateTime.year,
          taskTZDateTime.month, taskTZDateTime.day, hour, minutes);
      return scheduleDate;
    } else if (isMonthly) {
      DateTime taskDateTime = DateTime.parse(date!);
      tz.TZDateTime taskTZDateTime = tz.TZDateTime.from(taskDateTime, tz.local);
      tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, taskTZDateTime.year,
          taskTZDateTime.month, taskTZDateTime.day, hour, minutes);
      return scheduleDate;
    } else {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduleDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
      if (scheduleDate.isBefore(now)) {
        scheduleDate = scheduleDate.add(const Duration(days: 1));
      }
      return scheduleDate;
    }
  }

  tz.TZDateTime _convertTime(Task task, hour, int minutes) {
    String date = task.date!;
    print(task.remind);
    DateTime taskDateTime = DateTime.parse(date);
    tz.TZDateTime taskTZDateTime = tz.TZDateTime.from(taskDateTime, tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, taskTZDateTime.year,
        taskTZDateTime.month, taskTZDateTime.day, hour, minutes);

    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  Future<void> requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    Get.dialog(const Text("Welcome To Cheyyan"));
  }
}

Future selectNotification(String? payload) async {
  if (payload != null) {
    print('notification payload: $payload');
  } else {
    print("Notification Done");
  }

  if (payload == "Theme Changed") {
    print("Nothing navigated");
  } else {
    Get.to(() => NotifiedPage(label: payload));
  }
}
