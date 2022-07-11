import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/setting_pages/notification/notify_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../ads/adBanner.dart';
import '../../../component/costom_time_picker.dart';

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
  bool isThreeDaysAgo = false;
  bool isAWeekAgo = false;
  bool isADayAgo = false;
  bool isToday = false;

  List<bool>? list;

  //TRUEのマックスの数　通知の最高数
  int maxTrueValue = 1;

  String timeText = '';

  //変換の際に使うDATETIME型やつ
  DateTime now = DateTime.now();

  //タイムピッカーデフォルトの変数
  TimeOfDay _selectedTime = TimeOfDay(hour: 10, minute: 00);


  //スイッチのTRUEの制限の時に出すダイアログ
  limitTrueDialog() {
    var deviceSize = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          // titlePadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.fromLTRB(24.0,0,24.0,15.0),
          content: Text(
            "通知は、最大１つまで設定が\n可能です！",
            style: TextStyle(fontSize: deviceSize.height * 0.021),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                height: deviceSize.height * 0.048,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey, //ボタンの背景色
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: deviceSize.height * 0.02),
                  ),
                  onPressed: () async{
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
      isAWeekAgo = prefs.getBool('week') ?? false;
      isADayAgo = prefs.getBool('isADayAgo') ?? false;
      isToday = prefs.getBool('isToday') ?? false;
      String stringTimeData = prefs.getString('time') ?? "2022-06-22 10:00:00.000";
      _selectedTime = TimeOfDay.fromDateTime(
          DateTime.parse(stringTimeData));

      //状態をまとめて管理
      this.list = [isToday,isADayAgo,isThreeDaysAgo,isAWeekAgo];

    });
  }

  @override
  void initState(){
    super.initState();
    _restoreValues();
  }

  @override
  Widget build(BuildContext context) {
    //  timePickerを呼ぶための関数ーーーーーーーーーーーーーーーーーーーーーーーーー
    Future _pickTime(BuildContext context) async {
      //TODO24時間形式をFALSEにして端末の設定に関わらず、12時間形式で表示する↓
      //どうにかしてALWAYS24HOURFORMATをFALSEにする

      final TimeOfDay? timeValue = await customShowTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _selectedTime.hour, minute: _selectedTime.minute),
        cancelText: 'キャンセル',
        confirmText: "OK",
        //各々の携帯の設定に関わらず時刻選択の際は12時間フォーマットにする
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                //24時間フォーマット解除
                .copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );

      if (timeValue != null) {
        setState(() {
          _selectedTime = timeValue;
          _saveTime('time',  DateTime(
            now.year,
            now.month,
            now.day,
            _selectedTime.hour, // TimeOfDay
            _selectedTime.minute, //TimeOfDay
          ).toString());
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
                  fontSize: deviceSize.width * 0.043,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceSize.height * 0.064),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Padding(
            padding: deviceSize.height > 1000
                ? EdgeInsets.only(top: 25.0)
                : EdgeInsets.only(),
            child: Text('通知',
                style: TextStyle(
                    color: Theme.of(context).selectedRowColor,
                    fontSize: deviceSize.height * 0.023)),
          ),
          leading: Padding(
            padding: deviceSize.height > 1000
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
              _menuItem(context, title: "通知", child: _isOnSwitch(context)),

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
                      title: '前日に通知', child: _isADayAgoSwitch(context))
                  : SizedBox.shrink(),
              Container(
                width: deviceSize.width * 8,
                child: isOn
                    ? _menuItem(context,
                        title: "3日前に通知", child: _isThreeDaysAgoSwitch(context))
                    : SizedBox.shrink(),
              ),
              isOn
                  ? _menuItem(context,
                      title: "1週間前に通知", child: _isAWeekAgoSwitch(context))
                  : SizedBox.shrink(),

            //
              isOn
                  ? SizedBox.shrink()
                  : FutureBuilder(
                // 別の場所でFUTUREで通知ステータスを取得
                  future: getNotificationStatus(),
                  //snapshotにはFUTUREの関数の返り値が入る
                  builder: (context,snapshot) {
                    //通知ステータス == isGrantedだったら文字を表示しない
                    if(snapshot.data == true) {
                      return  SizedBox.shrink();
                    }
                    //通知ステータス == isGrantedじゃない（許可していない）場合は通知オンにしてテキストを表示する
                    return _openSettingText(context);
                  })

              // isOn
              //     ? SizedBox.shrink()
              //     : Column(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     SizedBox(height: deviceSize.height*0.22),
              //     RichText(
              //       maxLines: 2,
              //       text: TextSpan(
              //         style: TextStyle(
              //             color: Theme.of(context).secondaryHeaderColor,
              //             fontSize: deviceSize.height * 0.02
              //         ),
              //         children: [
              //           TextSpan(text: 'アプリの通知をご利用の際は'),
              //           TextSpan(
              //             text: 'こちら',
              //             style: TextStyle(
              //               color: Colors.lightBlueAccent,
              //               decoration: TextDecoration.underline,
              //             ),
              //             recognizer: TapGestureRecognizer()
              //               ..onTap = () async{
              //                 await openAppSettings();
              //               },
              //           ),
              //           TextSpan(text: 'から、\n'),
              //           TextSpan(text: 'スマホの通知設定をオンにしてください！'),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
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

  //line271で使うための通知のステータスを取得する関数
  Future getNotificationStatus() async{
    var status = await Permission.notification.status;
    return status.isGranted;
  }


  //　通知をオフにしている人に対しての通知の催促メッセージを出す関数
  Widget _openSettingText(BuildContext context) {

    var deviceSize = MediaQuery.of(context).size;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: deviceSize.height*0.2),
          RichText(
            text: TextSpan(
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: deviceSize.height * 0.018
              ),
              children: [
                TextSpan(text: 'アプリの通知をご利用の際は'),
                TextSpan(
                  text: 'こちら',
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async{
                      await openAppSettings();
                    },
                ),
                TextSpan(text: 'から、\n'),
                TextSpan(text: 'スマホの通知設定をオンにしてください！'),
                // TextSpan(text: status.toString()),
              ],
            ),
          ),
        ],
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
  Widget _isOnSwitch(context) {
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

  //3日前
  Widget _isThreeDaysAgoSwitch(context) {
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

              if(value == true){
                //もしTRUEが入ってきたら、TRUEの数数えて精査する
                var trueNum = list!.where((x) => x == true).length;
                if (trueNum >= maxTrueValue) {
                  limitTrueDialog();
                }
                //ここに入ると値更新できてる
                else{
                  list![2] = value; //true
                  setState(() {
                    isThreeDaysAgo = value;
                    _saveBool('isThreeDaysAgo', isThreeDaysAgo);
                    print("$isThreeDaysAgo");
                  });
                }
              }
              //switchオフになる時
              else{
                list![2] = value; //false
                setState(() {
                  isThreeDaysAgo = value;
                  _saveBool('isThreeDaysAgo', isThreeDaysAgo);
                  print("$isThreeDaysAgo");
                });
              }
            }
            notifyProvider.selectOnOff(isThreeDaysAgo);
          },
        ),
      ),
    );
  }

  //一週間前
  Widget _isAWeekAgoSwitch(context) {
    var notifyProvider = ref.read(NotifyProvider);
    var deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      width: deviceSize.height * 0.07,
      height: deviceSize.height * 0.055,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          value: isAWeekAgo,
          onChanged: (bool? value) {
            if (value != null) {
              if (value == true) {
                //もしTRUEが入ってきたら、TRUEの数数えて精査する
                var trueNum = list!.where((x) => x == true).length;
                if (trueNum >= maxTrueValue) {
                  limitTrueDialog();
                }
                //ここに入ると値更新できてる
                else {
                  list![3] = value; //true
                  setState(() {
                    isAWeekAgo = value;
                    _saveBool('week', isAWeekAgo);
                    print("$isAWeekAgo");
                  });
                }
              }
              //switchオフになる時
              else {
                list![3] = value; //false
                setState(() {
                  isAWeekAgo = value;
                  _saveBool('week', isAWeekAgo);
                  print("$isAWeekAgo");
                });
              }
            }
            notifyProvider.selectOnOff(isAWeekAgo);
          },
        ),
      ),
    );
  }

//前日
  Widget _isADayAgoSwitch(context) {
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
              if (value == true) {
                //もしTRUEが入ってきたら、TRUEの数数えて精査する
                var trueNum = list!.where((x) => x == true).length;
                if (trueNum >= maxTrueValue) {
                  limitTrueDialog();
                }
                //ここに入ると値更新できてる
                else {
                  list![1] = value; //true
                  setState(() {
                    isADayAgo = value;
                    _saveBool('isADayAgo', isADayAgo);
                    print("$isADayAgo");
                  });
                }
              }
              //switchオフになる時
              else {
                list![1] = value; //false
                setState(() {
                  isADayAgo = value;
                  _saveBool('isADayAgo', isADayAgo);
                  print("$isADayAgo");
                });
              }
            }
            notifyProvider.selectOnOff(isADayAgo);
          },
        ),
      ),
    );
  }

  //当日
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

            for(var item in list!){
              print(item);
            }
            if (value != null) {
              if (value == true) {

                //もしTRUEが入ってきたら、TRUEの数数えて精査する
                var trueNum = list!.where((x) => x == true).length;
                if (trueNum >= maxTrueValue) {
                  limitTrueDialog();
                }
                //ここに入ると値更新できてる
                else {
                  list![0] = value; //true
                  setState(() {
                    isToday = value;
                    _saveBool('isToday', isToday);
                    print("aaaaaaaaaaaa$isToday");
                  });
                }
              }
              //switchオフになる時(解除された時)
              else {
                list![0] = value; //false
                setState(() {
                  isToday = value;
                  _saveBool('isToday', isToday);
                  print("bbbbbb$isToday");
                });
              }
            }
            notifyProvider.selectOnOff(isToday);
          },
        ),
      ),
    );
  }
//  ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
}
