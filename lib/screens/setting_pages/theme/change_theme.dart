// 赤、青、黒、白、黄色、緑、オレンジ、ピンク、

import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/setting_pages/theme/theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../ads/AdBanner.dart';
import '../../calendar_screen.dart';
import 'package:flutter_deadline_management/screens/setting_pages/theme/theme_provider.dart'as theme;
import 'package:shared_preferences/shared_preferences.dart';

class ChangeThemeScreen extends StatefulHookConsumerWidget {
  static const String id = 'changeTheme';

  @override
  _ChangeThemeScreenState createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends ConsumerState<ChangeThemeScreen> {
  @override
  Widget build(BuildContext context) {

    var themeProvider = ref.watch(theme.ThemeProvider);

    Future _saveColorTheme(int index) async{
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme',index);
    }

    var deviceSize = MediaQuery.of(context).size;


    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceSize.height * 0.064),
        child: AppBar(
          title: Padding(
            padding: deviceSize.height > 900 ? EdgeInsets.only(top: 25.0) : EdgeInsets.only(),
            child: Text('テーマ着せ替え',
                style: TextStyle(color: Theme.of(context).selectedRowColor,fontSize: deviceSize.height * 0.023)),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          leading: Padding(
            padding: deviceSize.height > 900 ? EdgeInsets.all(15) : EdgeInsets.only(),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).selectedRowColor,
                size: deviceSize.height * 0.027,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(deviceSize.width * 0.12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //dark
                      _colorContainer(
                        context : context,
                        onPress: () {
                          themeProvider.changeDarkTheme();
                          _saveColorTheme(1);
                        },
                        color: Color(0xff212121),
                        //コンテナの真ん中にチェックボタンつけてる
                        child: themeProvider.currentTheme == darkTheme
                            ? Center(
                            child: Icon(
                                Icons.done, color: Colors.brown[300], size: deviceSize.width * 0.1))
                            : SizedBox.shrink(),
                      ),

                      Spacer(),

                      //pink
                      _colorContainer(
                        context : context,
                        onPress: () {
                          themeProvider.changePinkTheme();
                          _saveColorTheme(2);
                        },
                        color: Colors.pink[200],
                        //コンテナの真ん中にチェックボタンつけてる
                        child: themeProvider.currentTheme == pinkTheme
                            ? Center(
                            child: Icon(
                                Icons.done, color: Colors.brown, size: deviceSize.width * 0.1))
                            : SizedBox.shrink(),
                      ),

                      Spacer(),

                      //light
                      _colorContainer(
                        context : context,
                        onPress: () {
                          themeProvider.changeLightTheme();
                          _saveColorTheme(3);
                        },
                        color: Colors.white,
                        //コンテナの真ん中にチェックボタンつけてる
                        child: themeProvider.currentTheme == lightTheme
                            ? Center(
                            child: Icon(
                                Icons.done, color: Colors.brown, size: deviceSize.width * 0.1))
                            : SizedBox.shrink(),
                      ),

                      Spacer(),

                      //  blue
                      _colorContainer(
                          context : context,
                        onPress: () {
                          themeProvider.changeBlueTheme();
                          _saveColorTheme(4);
                        },
                        color: Colors.blue,
                        //コンテナの真ん中にチェックボタンつけてる
                        child: themeProvider.currentTheme == blueTheme
                            ? Center(
                            child: Icon(
                                Icons.done, color: Colors.brown, size: deviceSize.width * 0.1))
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(deviceSize.width * 0.12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //  orange
                      _colorContainer(
                        context : context,
                        onPress: () {
                          themeProvider.changeOrangeTheme();
                          _saveColorTheme(5);
                        },
                        color: Colors.orange,
                        //コンテナの真ん中にチェックボタンつけてる
                        child: themeProvider.currentTheme == orangeTheme
                            ? Center(
                            child: Icon(
                                Icons.done, color: Colors.brown, size: deviceSize.width * 0.1))
                            : SizedBox.shrink(),
                      ),

                      Spacer(),

                      //  red
                      _colorContainer(
                        context : context,
                        onPress: () {
                          themeProvider.changeRedTheme();
                          _saveColorTheme(6);
                        },
                        color: Colors.red,
                        //コンテナの真ん中にチェックボタンつけてる
                        child: themeProvider.currentTheme == redTheme
                            ? Center(
                            child: Icon(
                                Icons.done, color: Colors.brown, size: deviceSize.width * 0.1))
                            : SizedBox.shrink(),
                      ),

                      Spacer(),

                      //  green
                      _colorContainer(
                        context : context,
                        onPress: () {
                          themeProvider.changeGreenTheme();
                          _saveColorTheme(7);
                        },
                        color: Colors.green,
                        //コンテナの真ん中にチェックボタンつけてる
                        child: themeProvider.currentTheme == greenTheme
                            ? Center(
                            child: Icon(
                                Icons.done, color: Colors.brown, size: deviceSize.width * 0.1))
                            : SizedBox.shrink(),
                      ),

                      Spacer(),

                      //  yellow
                      _colorContainer(
                        context : context,
                        onPress: () {
                          themeProvider.changeYellowTheme();
                          _saveColorTheme(8);
                        },
                        color: Color(0xffF3D800),
                        //コンテナの真ん中にチェックボタンつけてる
                        child: themeProvider.currentTheme == yellowTheme
                            ? Center(
                                child: Icon(
                                    Icons.done, color: Colors.brown, size: deviceSize.width * 0.1))
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  //85↓
                  width: deviceSize.height * 0.1,
                  //40↓
                  height: deviceSize.height * 0.046,
                  child: ElevatedButton(
                    onPressed: () => Navigator.popUntil(
                        context, ModalRoute.withName(CalendarScreen.id)),
                    child: Text(
                      '決定',
                      style: TextStyle(
                      //16↓
                      fontSize: deviceSize.height * 0.018,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).disabledColor,
                      onPrimary: Colors.white,
                      elevation: 10
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: deviceSize.width,
            height: deviceSize.height*0.08,
            child: AdBanner(),
          ),
          SizedBox(height: deviceSize.height * 0.04)
        ],
      ),
    );
  }

  Widget _colorContainer(
      {required void Function()? onPress,
      required Color? color,
      Widget? child,required BuildContext context}) {
    var deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        width: deviceSize.height * 0.08,
        height: deviceSize.height * 0.08,
        child: child,
      ),
    );
  }
}
