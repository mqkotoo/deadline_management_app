import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/component/simekiri_tile.dart';
import 'package:flutter_deadline_management/model/calendar_model.dart';
import 'package:flutter_deadline_management/screens/setting_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
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
  final now = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  // タスクを編集するとき用のTextEditingController
  TextEditingController? _editController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      return contents;
    }

    //テーマ別に色を変えられるようにするためのやつ
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    return Scaffold(
        backgroundColor: Colors.pink[50],
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              "カレンダー",
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () =>
                      Navigator.pushNamed(context, SettingScreen.id)),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              //カレンダーの大きさ変えてる
              SizedBox(
                height: Platform.isIOS ? 410 : 340,

                // テーブルカレンダーを実装
                child: Card(
                  child: TableCalendar(

                    //カレンダーの大きさ変えれるようにするやつ
                    shouldFillViewport: true,

                    locale: 'ja_JP',
                    firstDay: DateTime.utc(now.year - 1, 1, 1),
                    lastDay: DateTime.utc(now.year + 1, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,

                    //カレンダーのマーカー表示するためのビルダー
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (events.isNotEmpty) {
                          return _buildEventsMarker(date, events,context);
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
                    daysOfWeekStyle: dayStyle,
                    // カレンダーの上の部分のスタイル
                    headerStyle: calendarHeadStyle(context),
                  ),
                ),
              ),

              //ちょっと隙間小さかったから空白を足してるよ
              const SizedBox(height: 3),

              // 今選択している日付をリストの上に表示する
              selectedDay(selectedDay: _selectedDay),

              //ちょっと隙間小さかったから空白を足してるよ
              SizedBox(height: 3),

              // タスクのリストを表示する
              Expanded(
                  child: _getEventsfromDay(_selectedDay).isEmpty
                      ? Center(
                    child : Text(
                      DateFormat.MMMEd('ja').format(_selectedDay) + 'の締め切りはありません',
                  ),
              )
                      : ListView(
                      children: _getEventsfromDay(_selectedDay)
                          .map((event) => Card(
                            //影設定
                            elevation: 7,
                            //カードの形の角を取る
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: CustomTile(
                              title: event['title'].toString(),
                              subtitle: event['detail'].toString(),
                              onTap: () {},
                            ),
                          ))
                          .toList()),
              ),
            ],
          ),
        ),

        // タスク作成ボタン
        floatingActionButton: FloatingActionButton(

          // テーマがDARKだったらとかのやつ
          backgroundColor: platformBrightness == Brightness.dark
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColor,

          // foregroundColor: Colors.red,
          // イベント追加ページに遷移
          onPressed: () async {
            await Navigator.pushNamed(context, AddEventScreen.id,
                //add_pageで使うやつを渡す
                arguments: Arguments(_selectedDay, false, {}));
            //上で帰ってくるの待って、SETSTATEで画面ぎゅいーん
            setState(() {});
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      );
  }
}

// イベントの数を数字で表示するためのウィジェット
Widget _buildEventsMarker(DateTime date, List events,context) {

  //テーマ別に色を変えられるようにするためのやつ
  final platformBrightness = MediaQuery.platformBrightnessOf(context);

  return Positioned(
    right: 5,
    bottom: 5,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: platformBrightness == Brightness.dark
            ? Colors.red[300]
            : Colors.pink[200],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    ),
  );
}
