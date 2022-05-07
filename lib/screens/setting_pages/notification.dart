import 'package:flutter/material.dart';


class SettingNotificationScreen extends StatefulWidget {
  static const String id = 'notification';

  @override
  State<SettingNotificationScreen> createState() => _SettingNotificationScreenState();
}

class _SettingNotificationScreenState extends State<SettingNotificationScreen> {

  //スイッチのオンオフのBOOL値
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('通知'),
      ),
      body:  ListView(
          children: [
              _menuItem(context,title: "通知", child: _switch()),
            _menuItem(context,title: "通知を受け取る時間", child: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
          ]
      ),
    );
  }

  Widget _menuItem(BuildContext context,
      {required String title, required Widget child, void Function()? onPress}) {

    //テーマ別に色を変えられるようにするためのやつ
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    return GestureDetector(
      onTap: onPress,
      child:Container(
          padding: EdgeInsets.symmetric(vertical: 14.0),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,13,0),
                child: child,
              ),
            ],
          )
      ),
    );
  }


  //オンオフのスイッチのウィジェット
  Widget _switch() {
    return Switch(
      value: isOn,
      onChanged: (bool? value) {
        if (value != null) {
          setState(() {
            isOn = value;
            print("$isOn");
          });
        }
      },
    );
  }


}