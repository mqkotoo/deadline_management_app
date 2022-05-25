import 'package:flutter/material.dart';


//DARK
ThemeData darkTheme = ThemeData.dark().copyWith(
  //フローティングアクションボタン、選択している日付の丸、カレンダーヘッダーの矢印
  accentColor: Colors.indigo,
  //カレンダーページのSCAFFOLDの背景色
  hoverColor: Colors.grey,
//  締め切りの数のマーカー
  indicatorColor: Colors.red[300],
//  選択した日付の文字の色、アップバーの色、その他全体で統一する白か黒のテキストカラー
  selectedRowColor: Colors.white,
//  add pageのラベルテキストの色
  bottomAppBarColor: Colors.white,
//  add pageのボタン、テキストの枠、ボタン、日付表示(primarycolorと一緒(lighttheme意外))
  disabledColor:Color(0xff212121)
);

//LIGHT
ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  // accentColor: Colors.red[300],
  accentColor: Colors.indigo,
  // hoverColor: Colors.red[50],
  hoverColor: Colors.grey[200],
  indicatorColor: Colors.red[300],
  selectedRowColor: Colors.black87,
  bottomAppBarColor: Colors.black,
  disabledColor: Colors.grey
);

//PINK
ThemeData pinkTheme = ThemeData(
  primaryColor: Colors.pink[100],
  accentColor: Colors.pink[100],
  hoverColor: Colors.pink[50],
  indicatorColor: Colors.pink[200],
  selectedRowColor: Colors.white,
  bottomAppBarColor:Colors.pink[100],
  disabledColor: Colors.pink[100]
);

//BLUE
ThemeData blueTheme = ThemeData(
  primaryColor: Colors.blue,
  accentColor: Colors.blue,
  hoverColor: Colors.blue[100],
  indicatorColor: Colors.red[300],
  selectedRowColor: Colors.white,
  bottomAppBarColor:Colors.blue,
  disabledColor: Colors.blue
);

//orange
ThemeData orangeTheme = ThemeData(
  primaryColor: Colors.orange,
  accentColor: Colors.orange,
  hoverColor: Colors.orange[100],
  indicatorColor: Colors.red[300],
  selectedRowColor: Colors.white,
  bottomAppBarColor:Colors.orange,
  disabledColor: Colors.orange
);

//red
ThemeData redTheme = ThemeData(
  primaryColor: Colors.red,
  accentColor: Colors.red,
  hoverColor: Colors.red[100],
  indicatorColor: Colors.black54,
  selectedRowColor: Colors.white,
  bottomAppBarColor:Colors.red,
  disabledColor: Colors.red
);

//green
ThemeData greenTheme = ThemeData(
  primaryColor: Colors.green,
  accentColor: Colors.green,
  hoverColor: Colors.green[100],
  indicatorColor: Colors.red[300],
  selectedRowColor: Colors.white,
  bottomAppBarColor:Colors.green,
  disabledColor: Colors.green
);

//yellow
ThemeData yellowTheme = ThemeData(
  primaryColor: Color(0xffF3D800),
  accentColor: Color(0xffF3D800),
  hoverColor: Colors.yellow[100],
  indicatorColor: Colors.red[300],
  selectedRowColor: Colors.white,
    bottomAppBarColor: Color(0xffF3D800),
  disabledColor: Color(0xffF3D800)
);