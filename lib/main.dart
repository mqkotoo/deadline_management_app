import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/add_event_screen.dart';
import 'package:flutter_deadline_management/screens/calendar_screen.dart';
import 'package:flutter_deadline_management/screens/setting_pages/account.dart';
import 'package:flutter_deadline_management/screens/setting_pages/setting_screen.dart';
import 'package:flutter_deadline_management/start_up.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //画面を縦に固定　横向きにならないようにする
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  initializeDateFormatting('jp')
      .then((_) => runApp(ProviderScope(child: MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //IPHONEの設定でダークモードにした時のテーマ
      darkTheme: ThemeData.dark().copyWith(
        accentColor: Colors.indigo,
      ),
      theme: ThemeData(
        // primaryColor: Color(0xfffaf0e6),
        primaryColor: Colors.pink[100],
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        CalendarScreen.id: (BuildContext context) => CalendarScreen(),
        SettingScreen.id: (BuildContext context) => SettingScreen(),
        StartUpPage.id: (BuildContext context) => StartUpPage(),
        AddEventScreen.id: (BuildContext context) => AddEventScreen(),
      },
      home: StartUpPage(),
    );
  }
}
