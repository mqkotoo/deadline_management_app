import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingNotificationScreen extends StatefulHookConsumerWidget {
  static const String id = 'notification';

  @override
  _SettingNotificationScreenState createState() => _SettingNotificationScreenState();
}

class _SettingNotificationScreenState extends ConsumerState<SettingNotificationScreen> {

  //スイッチのオンオフのBOOL値
  bool isOn = false;

  //タイムピッカーデフォルトの変数
  TimeOfDay _selectedTime = TimeOfDay(hour: 10, minute: 00);


  _saveBool(String key, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  _saveText(String key, String value) async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final timeText = useState("10:00");

    useEffect(() {
      Future(() async {
        var prefs = await SharedPreferences.getInstance();
        setState(() {
          isOn = prefs.getBool('isOn') ?? false;
          timeText.value = (prefs.getString('timeText') ?? '10:00');
        });
      });
      return null;
    }, const []);

    //  timePickerを呼ぶための関数ーーーーーーーーーーーーーーーーーーーーーーーーー
    Future _pickTime(BuildContext context) async{

      //TODO24時間形式をFALSEにして端末の設定に関わらず、12時間形式で表示する↓
      //どうにかしてALWAYS24HOURFORMATをFALSEにする

      final TimeOfDay? timeValue =
      await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 10, minute: 00),
        cancelText: 'キャンセル',
        hourLabelText: '',
        minuteLabelText: '',
        helpText: '',
        //各々の携帯の設定に関わらず時刻選択の際は12時間フォーマットにする
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context)
            //ここ↓
                .copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );

      if (timeValue != null) {
        setState(() {
          _selectedTime = timeValue;
        });
      }
    }

    //選択した時刻のテキスト
    String _getTimeText() {
      if (_selectedTime == null) {
        return '10:00';
      } else {
        var hours = _selectedTime.hour.toString();
        var minutes = _selectedTime.minute.toString().padLeft(2,'0');

        if(hours == '12') {
          hours = '24';
        }

        if(hours == '0') {
          hours = '12';
        }

          timeText.value = '$hours : $minutes';
          _saveText('timeText', timeText.value);

        print(timeText.value);
        return timeText.value;
      }
    }

    //時刻をリストの右側におくウィジェット
    Widget _displayTimeBox({void Function()? onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
              border : Border.all(color: Colors.grey)
          ),
          child: Center(
            child: Text(
              _getTimeText(),
              style: TextStyle(
                // color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),
            ),
          ),
        ),
      );
    }

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
                ? _menuItem(context,title: "通知を受け取る時間",
                child: _displayTimeBox(onTap : () => _pickTime(context)))
                : SizedBox.shrink()
          ]
      ),
    );
  }

  Widget _menuItem(BuildContext context,
      {required String title, required Widget child}) {

    //テーマ別に色を変えられるようにするためのやつ
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    return Container(
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
            _saveBool('isOn', isOn);
            print("$isOn");
          });
        }
      },
    );
  }
//  ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
}