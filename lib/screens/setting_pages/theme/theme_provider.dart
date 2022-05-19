import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/setting_pages/theme/theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final ThemeProvider = ChangeNotifierProvider((ref) => Theme());


class Theme extends ChangeNotifier {

  ThemeData currentTheme = lightTheme;

  void changeDarkTheme() {
    currentTheme = darkTheme;
    notifyListeners();
  }

  void changePinkTheme() {
    currentTheme = pinkTheme;
    notifyListeners();
  }

  void changeLightTheme() {
    currentTheme = lightTheme;
    notifyListeners();
  }

  void changeBlueTheme() {
    currentTheme = blueTheme;
    notifyListeners();
  }

  void changeOrangeTheme() {
    currentTheme = orangeTheme;
    notifyListeners();
  }

  void changeRedTheme() {
    currentTheme = redTheme;
    notifyListeners();
  }

  void changeGreenTheme() {
    currentTheme = greenTheme;
    notifyListeners();
  }

  void changeYellowTheme() {
    currentTheme = yellowTheme;
    notifyListeners();
  }

  // ThemeData getThemeIndex(int index) {
  //   switch(index) {
  //     case 1 : return darkTheme;
  //     case 2 : return pinkTheme;
  //     case 3 : return lightTheme;
  //     case 4 : return blueTheme;
  //     case 5 : return orangeTheme;
  //     case 6 : return redTheme;
  //     case 7 : return greenTheme;
  //     case 8 : return yellowTheme;
  //   }
  //   return lightTheme;
  // }



}