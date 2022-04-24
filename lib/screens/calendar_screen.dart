import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/model/calendar_model.dart';
import 'package:flutter_deadline_management/screens/setting_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../component/constants.dart';
import '../component/selectedDay.dart';
import 'add_event_screen.dart';

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
            SizedBox(
              height: 410,
              // テーブルカレンダーを実装
              child: Card(
                child: TableCalendar(
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return _buildEventsMarker(date, events,context);
                      }
                    },
                  ),
                  locale: 'ja_JP',
                  shouldFillViewport: true,
                  firstDay: DateTime.utc(now.year - 1, 1, 1),
                  lastDay: DateTime.utc(now.year + 1, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,

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
            const SizedBox(
              height: 11,
            ),
            // 今選択している日付をリストの上に表示する
            selectedDay(selectedDay: _selectedDay),

            // タスクのリストを表示する
            Expanded(
              // child: Padding(
              //   padding: EdgeInsets.only(left: 17.5),
              child: ListView(
                  children: _getEventsfromDay(_selectedDay)
                      .map((event) => Slidable(
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor: Colors.blue,
                                  icon: Icons.edit,
                                  label: '編集',
                                  // 編集ボタン押したときの処理
                                  onPressed: (value) async {
                                    await Navigator.pushNamed(
                                        context, AddEventScreen.id,
                                        //add_pageで使うやつを渡す
                                        arguments: Arguments(
                                            _selectedDay, true, event));
                                    //帰ってきて更新
                                    setState(() {});
                                  },
                                ),
                                SlidableAction(
                                  onPressed: (value) {
                                    // 削除する前にダイアログを出す
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("タスク削除"),
                                        content:
                                            Text('"${event['title']}"を削除しますか？'),
                                        actions: [
                                          // キャンセルボタン
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('キャンセル'),
                                          ),
                                          // 追加ボタン
                                          TextButton(
                                            onPressed: () async {
                                              await ref
                                                  .read(calendarProvider)
                                                  .delete(event);
                                              Navigator.pop(context);
                                              //困ったらSETSTATE
                                              setState(() {});
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                  label: '削除',
                                ),
                              ],
                            ),
                            child: Container(
                              height: 64,
                              child: ListTile(
                                title: Text(
                                  event["title"].toString(),
                                  style: TextStyle(fontSize: 17),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  event['detail'].toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 0.6,
                                  ),
                                ),
                              ),
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
