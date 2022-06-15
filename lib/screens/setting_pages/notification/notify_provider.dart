import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:timezone/browser.dart';
import 'package:timezone/timezone.dart' as tz;

final NotifyProvider = Provider((ref) => notifyProvider(ref.read));

class notifyProvider {
  notifyProvider(this._read);
  final Reader _read;
  //ios notification setting
  //android notification setting
  Future<void> isNotify(content, isThreeDaysAgo) async{
    if (content.isEmpty) {
      return;
    }
    final flnp = FlutterLocalNotificationsPlugin();
    flnp.initialize(
      const InitializationSettings(
        iOS: IOSInitializationSettings(),
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      ),
    );
    List content_title = [];
    var title = "";
    tz.TZDateTime date;
    for (var i = 0; i < content.length; i++) {
      content_title.add(content[i]['title']);
    }
    DateTime isDay = content[0]['at'].toDate();
    if (isThreeDaysAgo) {
      title = "3日後までのタスクが${content.length}個あります";
    } else {
      title = "今日は${content.length}個のタスクがあります";
    }

    if (isThreeDaysAgo) {
      date = tz.TZDateTime(tz.local, isDay.year, isDay.month, isDay.day, 23,50)
          .add(const Duration(days: -3));
    } else {
      date =
          tz.TZDateTime(tz.local, isDay.year, isDay.month, isDay.day, 23, 50);
    }

    flnp.zonedSchedule(
      0,
      title,
      content_title.join("、"),
      date,
      const NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName"),
        iOS: IOSNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
  //
  //     .then((_) => flnp.show(
  // 0,
  // '今日の締め切りが' + eventNum + '件あります',
  // content + ' です。',
  // const NotificationDetails(
  // iOS: IOSNotificationDetails(),
  // android: AndroidNotificationDetails('id', 'name',
  // channelDescription: "description",
  // importance: Importance.max,
  // priority: Priority.high),
  // )));

  Future<void> selectOnOff(bool isOn)  async {
    if (isOn == false) {
      offNotification();
    }
  }

  Future<void> offNotification() async {
    final flnp = FlutterLocalNotificationsPlugin();
    await flnp.cancelAll();
    print("通知オフ");
  }
}