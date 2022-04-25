import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

CalendarStyle calendarStyle(context) {
  final platformBrightness = MediaQuery.platformBrightnessOf(context);
  return CalendarStyle(
    // 選択した日のまるいやつのスタイル
    selectedDecoration: BoxDecoration(

        // テーマ別に色変えてる
        color: platformBrightness == Brightness.dark
            ? Theme.of(context).accentColor
            : Theme.of(context).primaryColor,
        shape: BoxShape.circle),
    // 今の日にちの選択のスタイル
    todayDecoration: BoxDecoration(
      color: Colors.grey,
      shape: BoxShape.circle,
    ),
  );
}

final dayStyle = DaysOfWeekStyle(
  weekdayStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.8),
  weekendStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red,fontSize: 12.8),
);

HeaderStyle calendarHeadStyle(context) {
  final platformBrightness = MediaQuery.platformBrightnessOf(context);
  return HeaderStyle(
    formatButtonVisible: false,
    titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
    titleCentered: true,
    leftChevronIcon: Icon(
      Icons.chevron_left,
      // テーマ別に矢印の色変えてる
      color: platformBrightness == Brightness.dark
          ? Theme.of(context).accentColor
          : Theme.of(context).primaryColor,
    ),
    rightChevronIcon: Icon(
        Icons.chevron_right,
      // テーマ別に矢印の色変えてる
      color: platformBrightness == Brightness.dark
          ? Theme.of(context).accentColor
          : Theme.of(context).primaryColor,
    ),
  );
}
