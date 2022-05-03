import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/log/welcome_screen.dart';

class SettingAccountScreen extends StatelessWidget {
  static const String id = 'account';
  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    //テーマ別に色を変えられるようにするためのやつ
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('設定'),
      ),
      body: ListView(
        children: [
          //ログアウト
          _menuItem(
              title: "ログアウト",
              textColor: platformBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.black54,
            //タップするとダイアログを表示する
            onPress: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("ログアウト"),
                content: Text('このアカウントをログアウトしますか'),
                actions: [
                  // キャンセルボタン
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('キャンセル'),
                  ),
                  // OKボタン
                  TextButton(
                    //ログアウトの実装
                    onPressed: () async{
                      await _auth.signOut();

                      // 全画面ポップしてWELCOME画面を表示する
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          WelcomeScreen.id, (route) => false);

                      print("ログアウトしました");
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //アカウント削除
          _menuItem(
            title: "アカウント削除",
            textColor: Colors.redAccent,
            // タップしたらダイアログを出す
            onPress: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("アカウント削除"),
                content: Text('このアカウントを削除しますか？'),
                actions: [
                  // キャンセルボタン
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('キャンセル'),
                  ),
                  // OKボタン
                  TextButton(
                    //仮にログアウトを実装している
                    onPressed: () async{
                      //アカウント削除の処理
                      final user = await _auth.currentUser!;
                      user.reauthenticateWithCredential;
                      user.delete();
                      //アカウントが持ってるデータを消す
                      FirebaseFirestore.instance
                          .collection("AppPackage")
                          .doc("v1")
                          .collection("users")
                          .doc(user.uid).delete();

                      // 全画面ポップしてWELCOME画面を表示する
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          WelcomeScreen.id, (route) => false);

                      print("アカウントを削除しました");
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
      {required String title,
      required void Function()? onPress,
      required Color textColor}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.0),
          decoration: new BoxDecoration(
              border: new Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey))),
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
                    fontWeight: FontWeight.bold,
                    // color: platformBrightness == Brightness.dark ? Colors.white : Colors.black54,
                    color: textColor,
                  ),
                ),
              ),
            ],
          )),
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
