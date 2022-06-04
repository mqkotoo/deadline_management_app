import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../screens/setting_pages/theme/theme.dart';


CalendarStyle calendarStyle(context) {

  var deviceSize = MediaQuery.of(context).size;

  return CalendarStyle(
    //カレンダーの数字の大きさ平日
    defaultTextStyle: TextStyle(fontSize: deviceSize.width * 0.04),
    //↑休日
    weekendTextStyle: TextStyle(fontSize: deviceSize.width * 0.04),
    //選択中の日付
    selectedTextStyle: TextStyle(fontSize: deviceSize.width * 0.04,color: Colors.white),
    //todayの選択中（グレーのとこ）
    todayTextStyle: TextStyle(fontSize: deviceSize.width * 0.04,color: Color(0xFFFAFAFA)),
    //選択月のあまりのスペースに前後の月の開始終わり日付
    outsideTextStyle: TextStyle(color: const Color(0xFFAEAEAE),fontSize: deviceSize.width * 0.04),
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

DaysOfWeekStyle dayStyle() {
  return DaysOfWeekStyle(
    weekdayStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.8),
    weekendStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red,fontSize: 12.8),
  );
}

HeaderStyle calendarHeadStyle(context) {
  var deviceSize = MediaQuery.of(context).size;
  return HeaderStyle(
    formatButtonVisible: false,
    titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: deviceSize.width * 0.036),
    titleCentered: true,
    leftChevronIcon: Icon(
      Icons.chevron_left,
      size: deviceSize.width * 0.058,
      // テーマ別に矢印の色変えてる
      color:Theme.of(context).accentColor
    ),
    rightChevronIcon: Icon(
        Icons.chevron_right,
        size: deviceSize.width * 0.058,
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
