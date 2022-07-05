import 'package:flutter/material.dart';


//DARK-----------------------------------------------------------------
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
  dividerColor:Color(0xff212121),
// timePickerの左下のボタンを背景と同化させる
  disabledColor: Colors.grey.shade800,

    buttonBarTheme: ButtonBarThemeData(
      alignment: MainAxisAlignment.center,
    ),

  timePickerTheme: TimePickerThemeData(

    dayPeriodColor: MaterialStateColor.resolveWith((states) =>
    states.contains(MaterialState.selected)
        ? Colors.tealAccent.shade700
        : Colors.white38),

    dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
    states.contains(MaterialState.selected)
        ? Colors.white
        : Colors.black87),

    hourMinuteColor: MaterialStateColor.resolveWith((states) =>
    states.contains(MaterialState.selected)
        ? Colors.tealAccent.shade700
        : Colors.white38),

    hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
    states.contains(MaterialState.selected)
        ? Colors.white
        : Colors.black),

    dialHandColor: Colors.tealAccent.shade700,

  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor:
      MaterialStateColor.resolveWith((states) => Colors.white),
      backgroundColor: MaterialStateColor.resolveWith(
              (states) => Colors.tealAccent.shade700),
    ),
  ),

);
//------------------------------------------------------------------

//LIGHT-------------------------------------------------------
ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  // accentColor: Colors.red[300],
  accentColor: Colors.indigo,
  // hoverColor: Colors.red[50],
  hoverColor: Colors.grey[200],
  indicatorColor: Colors.red[300],
  selectedRowColor: Colors.black87,
  bottomAppBarColor: Colors.black,
  dividerColor: Colors.grey,
  disabledColor: Colors.white,

  timePickerTheme:TimePickerThemeData(

    dayPeriodColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.indigo
            : Colors.white),

    dayPeriodTextColor:  MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.grey.shade700),

    hourMinuteColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.indigo
            : Colors.grey.shade300),

    hourMinuteTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.black),

    dialHandColor: Colors.indigo,

  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.indigo),
    ),

  ),

);
//---------------------------------------------------------------------

//PINK-----------------------------------------------------------------
ThemeData pinkTheme = ThemeData(
  primaryColor: Colors.pink[100],
  accentColor: Colors.pink[100],
  hoverColor: Colors.pink[50],
  indicatorColor: Colors.pink[200],
  selectedRowColor: Colors.white,
  bottomAppBarColor:Colors.pink[100],
  dividerColor: Colors.pink[100],
  disabledColor: Colors.white,

  timePickerTheme:TimePickerThemeData(

    dayPeriodColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.pink.shade100
            : Colors.white),

    dayPeriodTextColor:  MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.grey.shade700),

    hourMinuteColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.pink.shade100
            : Colors.grey.shade300),

    hourMinuteTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.black),

    dialHandColor: Colors.pink.shade100,

  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.pink.shade100),
    ),

  ),

);
//--------------------------------------------------------------------------

//BLUE----------------------------------------------------------------------
ThemeData blueTheme = ThemeData(
  primaryColor: Colors.blue,
  accentColor: Colors.blue,
  hoverColor: Colors.blue[100],
  indicatorColor: Colors.red[300],
  selectedRowColor: Colors.white,
  bottomAppBarColor:Colors.blue,
  dividerColor: Colors.blue,
  disabledColor: Colors.white,

  timePickerTheme:TimePickerThemeData(

    dayPeriodColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.blue
            : Colors.white),

    dayPeriodTextColor:  MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.grey.shade700),

    hourMinuteColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.blue
            : Colors.grey.shade300),

    hourMinuteTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.black),

    dialHandColor: Colors.blue,

  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
    ),

  ),

);
//-------------------------------------------------------------------------

//orange------------------------------------------------------------------
ThemeData orangeTheme = ThemeData(
  primaryColor: Colors.orange,
  accentColor: Colors.orange,
  hoverColor: Colors.orange[100],
  indicatorColor: Colors.red[300],
  selectedRowColor: Colors.white,
  bottomAppBarColor:Colors.orange,
  dividerColor: Colors.orange,
  disabledColor: Colors.white,

  timePickerTheme:TimePickerThemeData(

    dayPeriodColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.orange
            : Colors.white),

    dayPeriodTextColor:  MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.grey.shade700),

    hourMinuteColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.orange
            : Colors.grey.shade300),

    hourMinuteTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.black),

    dialHandColor: Colors.orange,

  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.orange),
    ),

  ),

);
//---------------------------------------------------------------------------

//red-------------------------------------------------------------------------
ThemeData redTheme = ThemeData(
  primaryColor: Colors.red,
  accentColor: Colors.red,
  hoverColor: Colors.red[100],
  indicatorColor: Colors.black54,
  selectedRowColor: Colors.white,
  bottomAppBarColor:Colors.red,
  dividerColor: Colors.red,
  disabledColor: Colors.white,

  timePickerTheme:TimePickerThemeData(

    dayPeriodColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.red
            : Colors.white),

    dayPeriodTextColor:  MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.grey.shade700),

    hourMinuteColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.red
            : Colors.grey.shade300),

    hourMinuteTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.black),

    dialHandColor: Colors.red,

  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
    ),

  ),

);
//---------------------------------------------------------------------------

//green---------------------------------------------------------------------------
ThemeData greenTheme = ThemeData(
  primaryColor: Colors.green,
  accentColor: Colors.green,
  hoverColor: Colors.green[100],
  indicatorColor: Colors.red[300],
  selectedRowColor: Colors.white,
  bottomAppBarColor:Colors.green,
  dividerColor: Colors.green,
  disabledColor: Colors.white,

  timePickerTheme:TimePickerThemeData(

    dayPeriodColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.green
            : Colors.white),

    dayPeriodTextColor:  MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.grey.shade700),

    hourMinuteColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.green
            : Colors.grey.shade300),

    hourMinuteTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.black),

    dialHandColor: Colors.green,

  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green),
    ),

  ),

);
//---------------------------------------------------------------------------

//yellow---------------------------------------------------------------------------
ThemeData yellowTheme = ThemeData(
  primaryColor: Color(0xffF3D800),
  accentColor: Color(0xffF3D800),
  hoverColor: Colors.yellow[100],
  indicatorColor: Colors.red[300],
  selectedRowColor: Colors.white,
  bottomAppBarColor: Color(0xffF3D800),
  dividerColor: Color(0xffF3D800),
  disabledColor: Colors.white,

  timePickerTheme:TimePickerThemeData(

    dayPeriodColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Color(0xffF3D800)
            : Colors.white),

    dayPeriodTextColor:  MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.grey.shade700),

    hourMinuteColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Color(0xffF3D800)
            : Colors.grey.shade300),

    hourMinuteTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.black),

    dialHandColor: Color(0xffF3D800),

  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
      backgroundColor: MaterialStateColor.resolveWith((states) => Color(0xffF3D800)),
    ),

  ),

);
//---------------------------------------------------------------------------