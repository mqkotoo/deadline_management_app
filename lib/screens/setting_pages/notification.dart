import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:intl/intl.dart';


class SettingNotificationScreen extends StatefulWidget {
  static const String id = 'notification';

  @override
  State<SettingNotificationScreen> createState() => _SettingNotificationScreenState();
}

class _SettingNotificationScreenState extends State<SettingNotificationScreen> {

  //スイッチのオンオフのBOOL値
  bool isOn = false;

  //タイムピッカーデフォルトの変数
  TimeOfDay _selectedTime = TimeOfDay(hour: 10, minute: 0);


  @override
  void initState() {
    super.initState();
  }

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

            //通知がオフだったら「通知を受け取る時間」を非表示にする
            isOn
                ? _menuItem(context,title: "通知を受け取る時間", child: _displayTimeBox(onTap : () => _pickTime(context)),
                onPress: () => print('onPressed'))
                : SizedBox.shrink()
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
                padding: const EdgeInsets.fromLTRB(0,0,20,0),
                child: child,
              ),
            ],
          )
      ),
    );
  }


  //オンオフのスイッチのウィジェットーーーーーーーーーーーーーーーーー
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
//  ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー


//  timePickerを呼ぶための関数ーーーーーーーーーーーーーーーーーーーーーーーーー
  void _pickTime(BuildContext context) {
    // final initialTime = TimeOfDay(hour: 10, minute: 0);

    //TimePickerの表示
    showMaterialTimePicker(
        context: context,
        selectedTime: _selectedTime,
      onChanged: (value) => setState(() => _selectedTime = value ),
    );

  }

  //選択した時刻のテキスト
  String _getTimeText() {
    if (_selectedTime == null) {
      return '10:00';
    } else {
      var hours = _selectedTime.hour.toString();
      var minutes = _selectedTime.minute.toString();

      // if(hours == '12') {
      //   hours = '24';
      // }
      //
      // if(hours == '0') {
      //   hours = '12';
      // }

      print(hours);

      return '$hours : ${minutes.padLeft(2,'0')}';
    }
  }

//時刻をリストの右側におくウィジェット
Widget _displayTimeBox({void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.18,
        height: MediaQuery.of(context).size.height * 0.04,
        decoration: BoxDecoration(
          border : Border.all(color: Colors.grey)
        ),
        child: Center(
          child: Text(
              _getTimeText(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.5
            ),
          ),
        ),

      ),
    );
}

}