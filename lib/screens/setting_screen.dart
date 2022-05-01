import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/welcome_screen.dart';

class SettingScreen extends StatelessWidget {
  static const String id = 'setting';
  final _auth = FirebaseAuth.instance;

  final items = ['アカウント','通知','テーマ着せ替え','設定をリセットする'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('設定'),
      ),
      body:  ListView(
          children: [
            _menuItem(title: "メニュー1", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
            _menuItem(title: "メニュー1", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
            _menuItem(title: "メニュー1", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
            _menuItem(title: "メニュー1", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
            _menuItem(title: "メニュー1", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
            _menuItem(title: "メニュー1", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
          ]
      ),
    );
  }
  Widget _menuItem({required String title, required Icon icon,required Function onPress}) {
    return GestureDetector(
      child:Container(
          padding: EdgeInsets.all(14.0),
          decoration: new BoxDecoration(
              border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black
                  ),
                ),
              ),
              // SizedBox(
              //   width: 220,
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,13,0),
                child: icon,
              ),
            ],
          )
      ),
      onTap: () {
        onPress;
      },
    );
  }
}

// ElevatedButton(
// style: ButtonStyle(
// // backgroundColor: Theme.of(context).primaryColor,
// ),
// child: Text('ログアウト'),
// onPressed: () {
// _auth.signOut();
//
// // 全画面ポップしてWELCOME画面を表示する
// Navigator.of(context)
//     .pushNamedAndRemoveUntil(WelcomeScreen.id, (route) => false);
//
// print("ログアウトしました");
// },
// ),