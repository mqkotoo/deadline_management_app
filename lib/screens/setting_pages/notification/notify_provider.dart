import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

final NotifyProvider = Provider((ref) => notifyProvider(ref.read));

class notifyProvider {
  notifyProvider(this._read);
  final Reader _read;
  //ios notification setting
  //android notification setting
  Future<void> isNotify(content, isToday,isADayAgo,isThreeDaysAgo,isAWeek) async {
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
    tz.TZDateTime? date;
    for (var i = 0; i < content.length; i++) {
      content_title.add(content[i]['title']);
    }
    DateTime isDay = content[0]['at'].toDate();


    if (isToday) {
      date = tz.TZDateTime(tz.local, isDay.year, isDay.month, isDay.day, 14,25);
      title = "今日：${content.length}個のタスク（予定）があります";
    }
    if (isADayAgo){
      date = tz.TZDateTime(tz.local, isDay.year, isDay.month, isDay.day, 14,25)
          .add(const Duration(days: -1));
      title = "明日：${content.length}個のタスク（予定）があります";
    }
    if (isThreeDaysAgo) {
      date = tz.TZDateTime(tz.local, isDay.year, isDay.month, isDay.day, 14,25)
          .add(const Duration(days: -3));
    }
    //一週間前の時の処理
    if (isAWeek) {
      date = tz.TZDateTime(tz.local, isDay.year, isDay.month, isDay.day, 14,25)
          .add(const Duration(days: -7));
      title = "一週間後：${content.length}個のタスク（予定）があります";
    }



    flnp.zonedSchedule(
      0,
      title,
      content_title.join("、"),
      date!,
      const NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName"),
        iOS: IOSNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

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