import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/setting_pages/notification/notify_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ads/AdBanner.dart';

class SettingNotificationScreen extends StatefulHookConsumerWidget {
  static const String id = 'notification';

  @override
  _SettingNotificationScreenState createState() =>
      _SettingNotificationScreenState();
}

class _SettingNotificationScreenState
    extends ConsumerState<SettingNotificationScreen> {
  //スイッチのオンオフのBOOL値
  bool isOn = false;
  bool isThreeDaysAgo = true;
  bool isAWeek = false;
  bool isADayAgo = false;
  bool isToday = false;

  String timeText = '';

  //タイムピッカーデフォルトの変数
  TimeOfDay _selectedTime = TimeOfDay(hour: 10, minute: 00);

  //通知オンオフの値を保存している
  _saveBool(String key, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  _saveTime(String key, String value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  _restoreValues() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      isOn = prefs.getBool('isOn') ?? false;
      isThreeDaysAgo = prefs.getBool('isThreeDaysAgo') ?? false;
      isAWeek = prefs.getBool('week') ?? false;
      isADayAgo = prefs.getBool('isADayAgo') ?? false;
      isToday = prefs.getBool('isToday') ?? false;

      print(isOn);
    });
  }

  @override
  void initState() {
    super.initState();
    _restoreValues();
  }

  @override
  Widget build(BuildContext context) {
    //  timePickerを呼ぶための関数ーーーーーーーーーーーーーーーーーーーーーーーーー
    Future _pickTime(BuildContext context) async {
      //TODO24時間形式をFALSEにして端末の設定に関わらず、12時間形式で表示する↓
      //どうにかしてALWAYS24HOURFORMATをFALSEにする

      final TimeOfDay? timeValue = await showTimePicker(
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
        var minutes = _selectedTime.minute.toString().padLeft(2, '0');

        if (hours == '12') {
          hours = '24';
        }

        if (hours == '0') {
          hours = '12';
        }

        timeText = '$hours : $minutes';

        // _saveText('timeText', timeText);

        print(timeText);
        return timeText;
      }
    }

    var deviceSize = MediaQuery.of(context).size;

    //時刻をリストの右側におくウィジェット
    Widget _displayTimeBox({void Function()? onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: deviceSize.width * 0.2,
          height: deviceSize.height * 0.05,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Center(
            child: Text(
              _getTimeText(),
              style: TextStyle(
                  // color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: deviceSize.width * 0.043),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceSize.height * 0.064),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Padding(
            padding: deviceSize.height > 900
                ? EdgeInsets.only(top: 25.0)
                : EdgeInsets.only(),
            child: Text('通知',
                style: TextStyle(
                    color: Theme.of(context).selectedRowColor,
                    fontSize: deviceSize.height * 0.023)),
          ),
          leading: Padding(
            padding: deviceSize.height > 900
                ? EdgeInsets.all(15)
                : EdgeInsets.only(),
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
            child: ListView(children: [
              _menuItem(context, title: "通知", child: _switch(context)),

              //通知がオフだったら「通知を受け取る時間」を非表示にする
              isOn
                  ? _menuItem(context,
                      title: "通知を受け取る時間",
                      child: _displayTimeBox(onTap: () => _pickTime(context)))
                  : SizedBox.shrink(),
              isOn
                  ? _menuItem(context,
                      title: "当日に通知", child: _isTodaySwitch(context))
                  : SizedBox.shrink(),
              isOn
                  ? _menuItem(context,
                      title: '前日に通知', child: _isDayAgoSwitch(context))
                  : SizedBox.shrink(),
              isOn
                  ? _menuItem(context,
                      title: "3日前に通知", child: _isThreeSwitch(context))
                  : SizedBox.shrink(),
              isOn
                  ? _menuItem(context,
                      title: "1週間後に通知", child: _isAWeekSwitch(context))
                  : SizedBox.shrink(),
            ],
            ),
          ),
          SizedBox(
            width: deviceSize.width,
            height: deviceSize.height * 0.08,
            child: AdBanner(),
          ),
          SizedBox(height: deviceSize.height * 0.04)
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context,
      {required String title, required Widget child}) {
    var deviceSize = MediaQuery.of(context).size;

    return Container(
        padding: EdgeInsets.symmetric(vertical: deviceSize.width * 0.034),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
        child: Row(
          children: [
            SizedBox(
              width: deviceSize.width * 0.05,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: deviceSize.height * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              // padding: const EdgeInsets.fromLTRB(0,0,20,0),
              padding: EdgeInsets.only(
                right: deviceSize.width * 0.05,
              ),
              child: child,
            ),
          ],
        ));
  }

  //オンオフのスイッチのウィジェットーーーーーーーーーーーーーーーーー
  Widget _switch(context) {
    var notifyProvider = ref.read(NotifyProvider);
    var deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      width: deviceSize.height * 0.07,
      height: deviceSize.height * 0.055,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          value: isOn,
          onChanged: (bool? value) {
            if (value != null) {
              setState(() {
                isOn = value;
                _saveBool('isOn', isOn);
                print("$isOn");
              });
            }
            notifyProvider.selectOnOff(isOn);
          },
        ),
      ),
    );
  }

  Widget _isThreeSwitch(context) {
    var notifyProvider = ref.read(NotifyProvider);
    var deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      width: deviceSize.height * 0.07,
      height: deviceSize.height * 0.055,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          value: isThreeDaysAgo,
          onChanged: (bool? value) {
            if (value != null) {
              setState(() {
                isThreeDaysAgo = value;
                _saveBool('isThreeDaysAgo', isThreeDaysAgo);
                print("$isThreeDaysAgo");
              });
            }
            notifyProvider.selectOnOff(isThreeDaysAgo);
          },
        ),
      ),
    );
  }

  Widget _isAWeekSwitch(context) {
    var notifyProvider = ref.read(NotifyProvider);
    var deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      width: deviceSize.height * 0.07,
      height: deviceSize.height * 0.055,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          value: isAWeek,
          onChanged: (bool? value) {
            if (value != null) {
              setState(() {
                isAWeek = value;
                _saveBool('week', isAWeek);
                print("$isAWeek");
              });
            }
            notifyProvider.selectOnOff(isAWeek);
          },
        ),
      ),
    );
  }

  Widget _isDayAgoSwitch(context) {
    var notifyProvider = ref.read(NotifyProvider);
    var deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      width: deviceSize.height * 0.07,
      height: deviceSize.height * 0.055,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          value: isADayAgo,
          onChanged: (bool? value) {
            if (value != null) {
              setState(() {
                isADayAgo = value;
                _saveBool('isADayAgo', isADayAgo);
                print("$isADayAgo");
              });
            }
            notifyProvider.selectOnOff(isADayAgo);
          },
        ),
      ),
    );
  }

  Widget _isTodaySwitch(context) {
    var notifyProvider = ref.read(NotifyProvider);
    var deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      width: deviceSize.height * 0.07,
      height: deviceSize.height * 0.055,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          value: isToday,
          onChanged: (bool? value) {
            if (value != null) {
              setState(() {
                isToday = value;
                _saveBool('isToday', isToday);
                print("$isToday");
              });
            }
            notifyProvider.selectOnOff(isToday);
          },
        ),
      ),
    );
  }
//  ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
}
