import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/add_event_screen.dart';
import 'package:flutter_deadline_management/screens/calendar_screen.dart';
import 'package:flutter_deadline_management/screens/setting_pages/change_theme.dart';
import 'package:flutter_deadline_management/screens/setting_pages/notification.dart';
import 'package:flutter_deadline_management/screens/setting_pages/setting_screen.dart';
import 'package:flutter_deadline_management/start_up.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

import 'model/theme/theme_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //画面を縦に固定　横向きにならないようにする
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  initializeDateFormatting('jp')
      .then((_) => runApp(ProviderScope(child: MyApp())));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    var themeProvider = ref.watch(ThemeProvider);


    return MaterialApp(
      //IPHONEの設定でダークモードにした時のテーマ
      theme: themeProvider.currentTheme,
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        CalendarScreen.id: (BuildContext context) => CalendarScreen(),
        SettingScreen.id: (BuildContext context) => SettingScreen(),
        StartUpPage.id: (BuildContext context) => StartUpPage(),
        AddEventScreen.id: (BuildContext context) => AddEventScreen(),
        SettingNotificationScreen.id : (BuildContext context) => SettingNotificationScreen(),
        ChangeThemeScreen.id : (BuildContext context) => ChangeThemeScreen(),
      },
      home: StartUpPage(),
    );
  }
}
