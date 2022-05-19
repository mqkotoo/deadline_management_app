import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../screens/setting_pages/theme/theme.dart';


CalendarStyle calendarStyle(context) {
  final platformBrightness = MediaQuery.platformBrightnessOf(context);
  return CalendarStyle(
    // 選択した日のまるいやつのスタイル
    selectedDecoration: BoxDecoration(
        // テーマ別に色変えてる
        color: Theme.of(context).accentColor,
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
      color:Theme.of(context).accentColor
    ),
    rightChevronIcon: Icon(
        Icons.chevron_right,
      // テーマ別に矢印の色変えてる
      color: Theme.of(context).accentColor
    ),
  );
}




//themeを保存するためにインデックスで色を管理するためにやつ
ThemeData getThemeIndex(int index) {
  switch(index) {
    case 1 : return darkTheme;
    case 2 : return pinkTheme;
    case 3 : return lightTheme;
    case 4 : return blueTheme;
    case 5 : return orangeTheme;
    case 6 : return redTheme;
    case 7 : return greenTheme;
    case 8 : return yellowTheme;
  }
  return lightTheme;
}
