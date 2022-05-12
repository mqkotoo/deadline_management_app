// 赤、青、黒、白、黄色、緑、オレンジ、ピンク、

import 'package:flutter/material.dart';

class ChangeThemeScreen extends StatefulWidget {

  static const String id = 'changeTheme';

  @override
  State<ChangeThemeScreen> createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends State<ChangeThemeScreen> {
  @override
  Widget build(BuildContext context) {
    Color? primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('テーマ着せ替え'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body : Center(
        child: Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
            ),
            onPressed: () {
            //  選択したら色が変わるようにする
            },
            child: Text('赤へ変更'),

          ),
        ),
      ),
    );
  }
}
