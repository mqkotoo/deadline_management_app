import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/component/simekiri_tile.dart';
import 'package:flutter_deadline_management/model/calendar_model.dart';
import 'package:flutter_deadline_management/screens/setting_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
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

  //スクロールを管理するコントローラとリスナーを定義
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();





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
      backgroundColor:
          platformBrightness == Brightness.dark ? Colors.grey : Colors.pink[50],
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
      body: Column(
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
                    child: Text(
                      DateFormat.MMMEd('ja').format(_selectedDay) +
                          'の締め切りはありません',
                    ),
                  )
                : ScrollablePositionedList.builder(
                    itemCount: _getEventsfromDay(_selectedDay).length,
                //スクロール関係のコントローラとリスナー追加
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                //itembuilderでひとつずつカードを生成していく(INDEX)が1,2,3..というふうになる
                itemBuilder: (context, index) {
                  /*
                  * 下の定義の[index]にも1,2,3..というふうに数字が流れる、
                  * 最終的には最後のカードの要素の値が入る
                  */
                      final event = _getEventsfromDay(_selectedDay)[index];
                      return Container(
                        /*
                  * その日のリストの最後のインデックスのカードの中身と、
                  * その日のリストの最後のカードの要素が一緒だったら、そのカードには下の余白を追加する
                  */
                        margin: event == _getEventsfromDay(_selectedDay).last
                            ? EdgeInsets.only(bottom: 30)
                            : EdgeInsets.only(),
                        child: Card(
                          //影設定
                          elevation: 7,
                          //カードの形の角を取る
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                          //自作のリストタイルを使う
                          child: CustomTile(
                            title: event['title'].toString(),
                            subtitle: event['detail'].toString(),

                            //popupmenuの実装ここから！　↓
                            popUpMenu: PopupMenuButton(
                              // menuを丸くする
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onSelected: (selectedMenu) async {
                                switch (selectedMenu) {
                                  case Menu.edit:
                                    await Navigator.pushNamed(
                                        context, AddEventScreen.id,
                                        arguments: Arguments(
                                            _selectedDay, true, event));
                                    //編集のページから帰ってきてからSETSTATEで更新する
                                    setState(() {});
                                    break;

                                //  削除を選択した時の処理
                                  case Menu.delete:
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

                                              // 更新する
                                              setState(() {});

                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                    break;
                                  case Menu.detail:
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(event['title']),
                                        content:
                                        Text(event['detail']),
                                        actions: [
                                          // 閉じるボタン
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('閉じる'),
                                          ),
                                        ],
                                      ),
                                    );
                                    break;
                                //  例外の時の処理はなし
                                  default:
                                    break;
                                }
                              },
                              child: Icon(Icons.more_vert),
                              itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<Menu>>[
                                //編集要素
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('編集'),
                                  ),
                                  value: Menu.edit,
                                ),

                                //divider
                                PopupMenuDivider(),

                                //削除要素
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text('削除'),
                                  ),
                                  value: Menu.delete,
                                ),

                                //divider
                                PopupMenuDivider(),

                                //詳細要素
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(Icons.notes),
                                    title: Text('詳細'),
                                  ),
                                  value: Menu.detail,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                }
          ),
          ),
        ],
      ),

      // タスク作成ボタン
      floatingActionButton : FloatingActionButton(
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

          //上で帰ってくるの待って、setStateで画面ぎゅいーん
          setState(() {});

          //締め切りの追加が終わったら、1番下のリスト表示
          itemScrollController.jumpTo(index: _getEventsfromDay(_selectedDay).length);
          },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      )
    );
  }
}

// イベントの数を数字で表示するためのウィジェット
Widget _buildEventsMarker(DateTime date, List events, context) {
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
            // : Colors.pink[200],
        : Theme.of(context).primaryColor
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
