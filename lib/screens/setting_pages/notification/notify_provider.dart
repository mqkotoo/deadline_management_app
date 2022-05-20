import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final NotifyProvider = Provider((ref) => notifyProvider());


class notifyProvider {
  Future<void> iosNotify() {
    final flnp = FlutterLocalNotificationsPlugin();
    return flnp.initialize(
      InitializationSettings(
        iOS: IOSInitializationSettings(),
      ),
    ).then((_) => flnp.show(0, 'title', 'body', NotificationDetails()));
  }

  Future<void> androidNotify() {
    final flnp = FlutterLocalNotificationsPlugin();
    return flnp.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    ).then((_) => flnp.show(0, 'title', 'body', NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        'channel_description',
      ),
    )));
  }

}
