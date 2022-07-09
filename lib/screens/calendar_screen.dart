import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/component/simekiri_tile.dart';
import 'package:flutter_deadline_management/model/calendar_model.dart';
import 'package:flutter_deadline_management/screens/setting_pages/notification/notify_provider.dart';
import 'package:flutter_deadline_management/screens/setting_pages/setting_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../component/constants.dart';
import '../component/selectedDay.dart';
import 'add_event_screen.dart';
import 'dart:io';

class CalendarScreen extends StatefulHookConsumerWidget {
  static const String id = 'calendar';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {


  //日にち分けしたときに一時的に予定が入るリスト
  List selectDatEvents = [];

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  //initStateでL31のnowから、二を引いてあげて（正常に前の年になるはず）、それをL32のnow2に代入してあげる。　first,lastDayにつかう
  final now = DateTime.now();
  //var now2 = DateTime

  bool isOn = false;
  // bool isThreeDaysAgo = true;
  // bool isAWeek = false;
  // bool isADayAgo = false;
  // bool isToday = false;
  String stringTimeData = "2022-06-23 10:00:00.000";
  TimeOfDay _selectedTime = TimeOfDay(hour: 10, minute: 00);

  TextEditingController _eventController = TextEditingController();

  //スクロールを管理するコントローラとリスナーを定義
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  _restoreValues() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      isOn = prefs.getBool('isOn') ?? false;
      // isThreeDaysAgo = prefs.getBool('isThreeDaysAgo') ?? true;
      // isAWeek = prefs.getBool('week') ?? false;
      // isADayAgo = prefs.getBool('isADayAgo') ?? false;
      // isToday = prefs.getBool('isToday') ?? false;
      stringTimeData = prefs.getString('time')!;
      _selectedTime =
          TimeOfDay.fromDateTime(DateTime.parse(stringTimeData));
      print(
          '${_selectedTime.hour.toString()},${_selectedTime.minute.toString()}');
    });
  }

  _showStartDialog() {
    var deviceSize = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          titlePadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.fromLTRB(24.0,0,24.0,15.0),
          title: Image.network(
            'https://pics.prcm.jp/8fc843cdea20f/81238464/jpeg/81238464_220x165.jpeg',
            height:320,
            fit: BoxFit.cover,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "通知を受け取りましょう！",
                style: TextStyle(
                    fontSize: deviceSize.height * 0.02,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: deviceSize.height * 0.015),
              Text(
               "通知を許可すると\nアプリ内で予定やタスクの通知が\n受け取れます！",
                style: TextStyle(fontSize: deviceSize.height * 0.018),
                textAlign: TextAlign.center,
              ),
            ],
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
                    //ステータスの定義
                    var status = await Permission.notification.status;

                    //通知の催促を初めて出すとき（ユーザーが一回目に使うとき）
                    if (status == PermissionStatus.denied) {
                      // リクエストを飛ばす
                      status = await Permission.notification.request();
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }



  @override
  void initState() {
    super.initState();
    _restoreValues();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var status = await Permission.notification.status;
      print(status.toString());
      //初回の人にダイアログ出す
      if (status != PermissionStatus.granted) {
        _showStartDialog();
        // limitTrueDialog();
      }
    });
  }



  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    //calendarモデルのeventsListを常に監視
    final events = ref.watch(calendarProvider).eventsList;

    //events
    //0:{"at":Timestamp2022年04月18日}
    //1:{"at":Timestamp2022年04月01日}
    //2:{"at":Timestamp2022年04月30日}
    List _getEventsfromDay(DateTime date) {
      // 分けられたいい感じのイベントたちが入る変数
      List contents = [];
      //一個ずつeventListの中身をスキャンしていく
      for (var i = 0; i < events.length; i++) {
        //イベントたちの登録されている日にちのTimeStampをDateTimeに変換
        DateTime isDay = events[i]['at'].toDate();
        //イベントたちのDateTimeとカレンダーのDateTimeの比較
        if (DateTime(date.year, date.month, date.day)
            .isAtSameMomentAs(DateTime(isDay.year, isDay.month, isDay.day))) {
          //4月18日と4月18日のように日にちが同じだったらcontentsに追加
          contents.add(events[i]);
        }
      }

      //// ここで読んじゃうと、30回くらいこの処理を繰り返してしまうから、どこで呼ぶか考えている
      ////                      ↓　　↓


        if (isOn) {
          ref.watch(NotifyProvider).isNotify(contents,stringTimeData);
          print(
              '${_selectedTime.hour.toString()},${_selectedTime.minute.toString()}');
          print(contents);
        }

      return contents;
    }


    return Scaffold(
      backgroundColor: Theme.of(context).hoverColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceSize.height * 0.052),
        child: AppBar(
          // elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          title: Padding(
            padding: deviceSize.height > 1000
                ? EdgeInsets.only(top: 8.0)
                : EdgeInsets.only(),
            child: Text(
              "カレンダー",
              style: TextStyle(
                  color: Theme.of(context).selectedRowColor,
                  fontSize: deviceSize.height * 0.023),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                  right: deviceSize.width * 0.01,
                  top: deviceSize.height > 1000 ? 5 : 0),
              child: IconButton(
                icon: Icon(Icons.settings,
                    size: deviceSize.height * 0.032,
                    color: Theme.of(context).selectedRowColor),
                onPressed: () => Navigator.pushNamed(context, SettingScreen.id),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          //カレンダーの大きさ変えてる
          Expanded(
            flex: 5,
            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              // テーブルカレンダーを実装
              child: TableCalendar(
                daysOfWeekHeight: deviceSize.height * 0.02,
                //カレンダーの大きさ変えれるようにするやつ
                shouldFillViewport: true,
                locale: 'ja_JP',
                //NOW
                //↓の書き方だと一月とか二月はおかしくなる気がする
                // firstDay: DateTime.utc(now.year, now.month-2, 1),
                firstDay: DateTime.utc(now.year - 1, 1, 1),
                lastDay: DateTime.utc(now.year + 1, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,

                //カレンダーのマーカー表示するためのビルダー
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return _buildEventsMarker(date, events, context);
                    }
                  },
                ),

                // カレンダーのフォーマットを月毎にしかできなくする
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                },

                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _getEventsfromDay(_selectedDay);
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },

                // イベントを読み込む
                eventLoader: _getEventsfromDay,
                // カレンダーのスタイル
                calendarStyle: calendarStyle(context),
                daysOfWeekStyle: dayStyle(context),
                // カレンダーの上の部分のスタイル
                headerStyle: calendarHeadStyle(context),
              ),
            ),
          ),

          //ちょっと隙間小さかったから空白を足してるよ
          SizedBox(height: deviceSize.height * 0.0034),

          // 今選択している日付をリストの上に表示する
          selectedDay(
            selectedDay: _selectedDay,
          ),

          //ちょっと隙間小さかったから空白を足してるよ
          SizedBox(height: deviceSize.height * 0.0034),

          // タスクのリストを表示する
          Expanded(
            flex: 4,
            child: _getEventsfromDay(_selectedDay).isEmpty
                ? Padding(
                    padding: EdgeInsets.only(bottom: deviceSize.height * 0.029),
                    child: Center(
                      child: Text(
                        DateFormat.MMMEd('ja').format(_selectedDay) +
                            'のタスクはありません',
                        style: TextStyle(fontSize: deviceSize.height * 0.017),
                      ),
                    ),
                  )
                : ScrollablePositionedList.builder(
                    itemCount: _getEventsfromDay(_selectedDay).length,
                    //スクロール関係のコントローラとリスナー追加
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                    //itembuilderでひとつずつカードを生成していく(INDEX)が1,2,3..というふうになる
                    itemBuilder: (context, index) {
                      // 下の定義の[index]にも1,2,3..というふうに数字が流れる、
                      // 最終的には最後のカードの要素の値が入る
                      final event = _getEventsfromDay(_selectedDay)[index];
                      return Container(
                        //その日のリストの最後のインデックスのカードの中身と、
                        // その日のリストの最後のカードの要素が一緒だったら、そのカードには下の余白を追加する
                        margin: event == _getEventsfromDay(_selectedDay).last
                            ? EdgeInsets.only(bottom: deviceSize.height * 0.025)
                            : EdgeInsets.only(),
                        //cardをタップすると締め切りの詳細が見れるようにする
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.pushNamed(
                                context,
                                // IOSにもPAGE_TRANSITIONを使うとスワイプでポップできなくなるからANDROIDだけ適応
                                Platform.isAndroid
                                    ? '/add_hori'
                                    : AddEventScreen.id,
                                arguments:
                                    Arguments(_selectedDay, true, event));
                            //編集のページから帰ってきてからSETSTATEで更新する
                            setState(() {});
                          },
                          child: Card(
                            //影設定
                            elevation: 5,
                            //カードの形の角を取る
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            //自作のリストタイルを使う
                            child: CustomTile(
                              title: event['title'].toString(),
                              subtitle: event['detail'].toString(),
                              icon: Icon(
                                Icons.navigate_next,
                                size: deviceSize.height * 0.027,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
            ),
          ),
        ],
      ),

      // タスク作成ボタン
      floatingActionButton: SizedBox(
        // 65↓
        width: deviceSize.height * 0.075,
        //65↓
        height: deviceSize.height * 0.075,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          // イベント追加ページに遷移
          onPressed: () async {
            final isAdd = await Navigator.pushNamed(
              context,
              //add eventにしたからのアニメーションをつけて画面遷移する main.dart L71参照
              Platform.isIOS ? '/add_ver' : AddEventScreen.id,
              //add_pageで使うやつを渡す
              arguments: Arguments(_selectedDay, false, {}),
            );

            //上で帰ってくるの待って、setStateで画面ぎゅいーん
            setState(() {});

            //締め切りの追加が終わったら、1番下のリスト表示
            // もし締め切りを追加しなかったらスクロールしない
            if (isAdd == true && _getEventsfromDay(_selectedDay).isNotEmpty) {
              itemScrollController.jumpTo(
                  index: _getEventsfromDay(_selectedDay).length);
            } else {}
            print(isAdd);
          },

          child: Icon(
            Icons.add,
            color: Colors.white,
            size: deviceSize.height * 0.048,
          ),
        ),
      ),
    );
  }

// イベントの数を数字で表示するためのウィジェット
  Widget _buildEventsMarker(DateTime date, List events, context) {
    var deviceSize = MediaQuery.of(context).size;
    return Positioned(
      right: 5,
      bottom: 5,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).indicatorColor
            // : Theme.of(context).primaryColor
            ),
        // 16↓
        width: deviceSize.height * 0.018,
        //16↓
        height: deviceSize.height * 0.018,
        child: Center(
          child: Text(
            '${events.length}',
            style: TextStyle().copyWith(
              color: Colors.white,
              fontSize: deviceSize.height * 0.014,
            ),
          ),
        ),
      ),
    );
  }
}
