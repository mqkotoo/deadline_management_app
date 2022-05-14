import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/model/theme/theme.dart';
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

}