import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';



final NotifyProvider = Provider((ref) => notifyProvider());


class notifyProvider {

  //ios notification setting
  Future<void> iosNotify(String eventNum, String content) {
    final flnp = FlutterLocalNotificationsPlugin();
    return flnp.initialize(
      InitializationSettings(
        iOS: IOSInitializationSettings(),
      ),
    ).then((_) => flnp.show(0, '今日の締め切りが' + eventNum +'件あります', content + ' です。', NotificationDetails()));
  }

  //android notification setting
  Future<void> androidNotify() {
    final flnp = FlutterLocalNotificationsPlugin();
    return flnp.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    ).then((_) => flnp.show(0, 'title', 'body', NotificationDetails(
      android: AndroidNotificationDetails(
        'id',
        'name',
          channelDescription: "description",
          importance: Importance.max,
        priority: Priority.high
      ),
    )));
  }

}