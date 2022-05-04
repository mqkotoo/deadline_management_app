import 'package:flutter/material.dart';
class SettingScreen extends StatelessWidget {
  static const String id = 'setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('設定'),
        ),
      body:  ListView(
          children: [
            _menuItem(context,title: "アカウント", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
            _menuItem(context,title: "通知", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
            _menuItem(context,title: "テーマ着せ替え", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
            _menuItem(context,title: "プライバシーポリシー", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
            _menuItem(context,title: "お問い合わせ", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
            _menuItem(context,title: "このアプリの使い方", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
            _menuItem(context,title: "利用規約", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
          ]
      ),
    );
  }
  Widget _menuItem(BuildContext context, {required String title, required Icon icon,required void Function()? onPress}) {

    //テーマ別に色を変えられるようにするためのやつ
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    return GestureDetector(
      onTap: onPress,
      child:Container(
          padding: EdgeInsets.symmetric(vertical: 14.0),
          decoration: new BoxDecoration(
              border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: platformBrightness == Brightness.dark ? Colors.white : Colors.black54,
                  ),
                ),
              ),
              // SizedBox(
              //   width: 220,
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,13,0),
                child: icon,
              ),
            ],
          )
      ),
    );
  }
}