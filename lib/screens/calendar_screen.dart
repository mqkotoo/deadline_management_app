import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/setting_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import '../component/constants.dart';
import '../component/selectedDay.dart';
import '../event.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CalendarScreen extends StatefulWidget {
  static const String id = 'calendar';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<DateTime, List<Event>> selectedEvents;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final now = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  // タスクを編集するとき用のTextEditingController
  TextEditingController? _editController;

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('カレンダー'),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, SettingScreen.id)),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 410,
            // テーブルカレンダーを実装
            child: TableCalendar(
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return _buildEventsMarker(date, events);
                  }
                },
              ),
              locale: 'ja_JP',
              shouldFillViewport: true,
              firstDay: DateTime.utc(now.year - 1, 1, 1),
              lastDay: DateTime.utc(now.year + 1, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
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
              calendarStyle: calendarStyle,
              daysOfWeekStyle: dayStyle,
              // カレンダーの上の部分のスタイル
              headerStyle: calendarHeadStyle,
            ),
          ),
          SizedBox(
            height: 11,
          ),

          // 今選択している日付をリストの上に表示する
          selectedDay(selectedDay: _selectedDay),

      // タスクのリストを表示する
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 17.5),
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
                    onPressed: (value) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AlertDialog(
                              title: Text("タスク編集"),
                              content: TextFormField(
                                // イニシャルバリューを指定↓
                                controller: _editController =
                                    TextEditingController(text: event.title),
                                autofocus: true,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () => _editController!.clear(),
                                  ),
                                ),
                              ),
                              actions: [
                                // キャンセルボタン
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _editController!.clear();
                                  },
                                  child: Text('キャンセル'),
                                ),

                                // 更新ボタン
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      // 無理矢理値アップデート
                                      // 今あるやつ削除
                                      selectedEvents[_selectedDay]!
                                          .remove(event);
                                      // 追加
                                      selectedEvents[_selectedDay]!.add(
                                        Event(title: _editController!.text),
                                      );

                                      // 値アップデート
                                      // selectedEvents[_selectedDay]![0] =
                                      //   Event(title: _eventController.text);
                                    });
                                    print(_editController!.text);
                                    Navigator.pop(context);
                                    _editController!.clear();
                                  },
                                  child: Text('更新'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
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
                          content: Text('"${event.title}"を削除しますか？'),
                          actions: [
                            // キャンセルボタン
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('キャンセル'),
                            ),
                            // 追加ボタン
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  // 削除の処理を書く
                                  selectedEvents[_selectedDay]!.remove(event);
                                });
                                Navigator.pop(context);
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
                  child: ListTile(
              title: Text(event.title),
            ),

                ))
                .toList()),

        ),
      ),
        ],
      ),

      // タスク作成ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  // イベント追加の際のモーダル
  _showAddDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AlertDialog(
            title: Text("タスク追加"),
            content: TextField(
              controller: _eventController,
              autofocus: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => _eventController.clear(),
                ),
              ),
            ),
            actions: [
              // キャンセルボタン
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _eventController.clear();
                },
                child: Text('キャンセル'),
              ),
              // 追加ボタン
              TextButton(
                onPressed: () {
                  if (_eventController.text.isEmpty) {
                  } else {
                    if (selectedEvents[_selectedDay] != null) {
                      selectedEvents[_selectedDay]!.add(
                        Event(title: _eventController.text),
                      );
                    } else {
                      selectedEvents[_selectedDay] = [
                        Event(title: _eventController.text)
                      ];
                    }
                  }
                  print(_eventController.text);
                  Navigator.pop(context);
                  _eventController.clear();
                  setState(() {});
                  return;
                },
                child: Text('追加'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// イベントの数を数字で表示するためのウィジェット
Widget _buildEventsMarker(DateTime date, List events) {
  return Positioned(
    right: 5,
    bottom: 5,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red[300],
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
