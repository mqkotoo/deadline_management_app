import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/calendar_screen.dart';
import 'package:flutter_deadline_management/screens/login_screen.dart';
import 'package:flutter_deadline_management/screens/registration_screen.dart';
import 'package:flutter_deadline_management/screens/setting_screen.dart';
import 'package:flutter_deadline_management/screens/welcome_screen.dart';
import 'package:flutter_deadline_management/start_up.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initializeDateFormatting('jp')
      .then((_) => runApp(ProviderScope(child: MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        WelcomeScreen.id: (BuildContext context) => WelcomeScreen(),
        LoginScreen.id: (BuildContext context) => LoginScreen(),
        RegistrationScreen.id: (BuildContext context) => RegistrationScreen(),
        CalendarScreen.id: (BuildContext context) => CalendarScreen(),
        SettingScreen.id: (BuildContext context) => SettingScreen(),
        StartUpPage.id: (BuildContext context) => StartUpPage(),
      },

      // ログインしているかしていないかで最初に表示するページを変える処理
      home: FirebaseAuth.instance.currentUser != null
          ? StartUpPage()
          : WelcomeScreen(),
    );
  }
}
