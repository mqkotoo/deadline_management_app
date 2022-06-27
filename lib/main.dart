import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/add_event_screen.dart';
import 'package:flutter_deadline_management/screens/calendar_screen.dart';
import 'package:flutter_deadline_management/screens/setting_pages/notification/notify_provider.dart';
import 'package:flutter_deadline_management/screens/setting_pages/theme/change_theme.dart';
import 'package:flutter_deadline_management/screens/setting_pages/how_to_use/how_to_use.dart';
import 'package:flutter_deadline_management/screens/setting_pages/notification/notification.dart';
import 'package:flutter_deadline_management/screens/setting_pages/setting_screen.dart';
import 'package:flutter_deadline_management/screens/setting_pages/theme/theme_provider.dart';
import 'package:flutter_deadline_management/start_up.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'component/constants.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));
  MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //画面を縦に固定　横向きにならないようにする
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  initializeDateFormatting('jp')
      .then((_) => runApp(ProviderScope(child: MyApp())));
}


class MyApp extends StatefulHookConsumerWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    getColorTheme();
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
            (_) => _showStartDialog()
    );
  }

  Future<void> _showStartDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          title : Image.network(
            'https://pics.prcm.jp/8fc843cdea20f/81238464/jpeg/81238464_220x165.jpeg',
            height: 200,
            fit: BoxFit.cover,
          ),
          content: Text("テキストテキストテキスト"),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future getColorTheme() async {
    var prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt('theme') ?? 0;
    print(index);
    var themeProvider = ref.watch(ThemeProvider);
    themeProvider.currentTheme = getThemeIndex(index, context);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ThemeProvider);



    return MaterialApp(
      theme: themeProvider.currentTheme,
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        CalendarScreen.id: (BuildContext context) => CalendarScreen(),
        SettingScreen.id: (BuildContext context) => SettingScreen(),
        StartUpPage.id: (BuildContext context) => StartUpPage(),
        AddEventScreen.id: (BuildContext context) => AddEventScreen(),
        SettingNotificationScreen.id: (BuildContext context) =>
            SettingNotificationScreen(),
        ChangeThemeScreen.id: (BuildContext context) => ChangeThemeScreen(),
        HowToUseScreen.id: (BuildContext context) => HowToUseScreen()
      },

      home: StartUpPage(),

      //add event page に遷移するときにしたからのアニメーションをつけるためのセッティング
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/add_ver':
            return PageTransition(
              child: AddEventScreen(),
              duration: Duration(milliseconds: 210),
              reverseDuration: Duration(milliseconds: 210),
              curve: Curves.linear,
              type: PageTransitionType.bottomToTop,
              settings: settings,
            );
          case '/add_hori':
            return PageTransition(
              child: AddEventScreen(),
              duration: Duration(milliseconds: 175),
              reverseDuration: Duration(milliseconds: 170),
              type: PageTransitionType.rightToLeft,
              settings: settings,
            );
          default:
            return null;
        }
      },
    );
  }
}

