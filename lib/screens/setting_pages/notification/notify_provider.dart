import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

final NotifyProvider = Provider((ref) => notifyProvider(ref.read));

class notifyProvider {
  notifyProvider(this._read);
  final Reader _read;
  //ios notification setting
  //android notification setting
  Future<void> isNotify(content,String stringTimeData) async {

    var prefs = await SharedPreferences.getInstance();
    final isThreeDaysAgo = prefs.getBool('isThreeDaysAgo') ?? true;
    final isAWeek = prefs.getBool('week') ?? false;
    final isADayAgo = prefs.getBool('isADayAgo') ?? false;
    final isToday = prefs.getBool('isToday') ?? false;
    print("カレンダーでゲットした時間 : " + stringTimeData);

    //通知の時刻選択できるページで指定した時刻をDateTime型っぽく文字列にしたもの。
    //これを使ってこのページでの、通知のスケジュールの何時何分のところを指定する
    TimeOfDay _selectedTime =
        TimeOfDay.fromDateTime(DateTime.parse(stringTimeData));

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

    tz.TZDateTime? date;
    for (var i = 0; i < content.length; i++) {
      content_title.add(content[i]['title']);
    }

    // 入っている予定の日付
    DateTime day = content[0]['at'].toDate();
    //入っている予定の時間軸の点を定義
    DateTime isDay = DateTime(day.year, day.month, day.day,
        _selectedTime.hour.toInt(), _selectedTime.minute.toInt());

    //入っている予定が過去だったら、もしくは通知の設定をした時刻より過去だったら、通知の処理を走らせない
    if (isDay.isBefore(DateTime.now())) {
      return;
    }

    //当日に通知
    if (isToday) {
      date = tz.TZDateTime(tz.local, isDay.year, isDay.month, isDay.day,
          _selectedTime.hour.toInt(),_selectedTime.minute.toInt());

      flnp.zonedSchedule(
        0,
        "今日は${content.length}個のタスク（予定）があります",
        "${content_title.join("、")} です！",
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

    //前日に通知
    if (isADayAgo){
      date = tz.TZDateTime(tz.local, isDay.year, isDay.month, isDay.day, _selectedTime.hour.toInt(),_selectedTime.minute.toInt())
      //同時に通知がある場合来なくなるので、タイミングをずらしてみる
          .add(const Duration(days: -1,seconds: -1));

      flnp.zonedSchedule(
        1,
        "明日は${content.length}個のタスク（予定）があります",
        "${content_title.join("、")} です！",
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

    //三日前に通知
    if (isThreeDaysAgo) {
      date = tz.TZDateTime(tz.local, isDay.year, isDay.month, isDay.day, _selectedTime.hour.toInt(),_selectedTime.minute.toInt())
          .add(const Duration(days: -3));

      flnp.zonedSchedule(
        2,
        "３日後に${content.length}このタスク（予定）があります",
        "${content_title.join("、")} です！",
        date,
        const NotificationDetails(
          android: AndroidNotificationDetails(
              "channelId", "channelName",
          ),
          iOS: IOSNotificationDetails(),
        ),
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
    }

    //一週間前に通知
    if (isAWeek) {
      date = tz.TZDateTime(tz.local, isDay.year, isDay.month, isDay.day, _selectedTime.hour.toInt(),_selectedTime.minute.toInt())
          .add(const Duration(days: -7));

      flnp.zonedSchedule(
        3,
        "１週間に${content.length}個のタスク（予定）があります",
        "${content_title.join("、")} です！",
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