// 赤、青、黒、白、黄色、緑、オレンジ、ピンク、

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/theme/theme_provider.dart' as theme;

class ChangeThemeScreen extends StatefulHookConsumerWidget {

  static const String id = 'changeTheme';

  @override
  _ChangeThemeScreenState createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends ConsumerState<ChangeThemeScreen> {
  @override
  Widget build(BuildContext context) {

    var themeProvider = ref.watch(theme.ThemeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('テーマ着せ替え'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              onPressed: () {
              //  選択したら色が変わるようにする
                themeProvider.changeDarkTheme();
              },
              child: Text('ダークモードへ変更'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                //  選択したら色が変わるようにする
                themeProvider.changePinkTheme();
              },
              child: Text('pinkへ変更'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeColor extends StatelessWidget {
  const ChangeColor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

