import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

const calendarStyle = CalendarStyle(
  // 選択した日のまるいやつのスタイル
  selectedDecoration: BoxDecoration(
      color: Colors.blueAccent,
      shape: BoxShape.circle),
  // 今の日にちの選択のスタイル
  todayDecoration: BoxDecoration(
    color: Colors.grey,
    shape: BoxShape.circle,
  ),
);

const dayStyle = DaysOfWeekStyle(
  weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
  weekendStyle: TextStyle(
      fontWeight: FontWeight.bold, color: Colors.red),
);

const calendarHeadStyle = HeaderStyle(
  formatButtonVisible: false,
  titleTextStyle:
  TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
  titleCentered: true,
);