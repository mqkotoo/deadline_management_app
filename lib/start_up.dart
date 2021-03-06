import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/model/calendar_model.dart';
import 'package:flutter_deadline_management/screens/calendar_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';





class StartUpPage extends HookConsumerWidget {
  static const String id = 'start';

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //  ユーザーがいたらカレンダースクリーンに飛んで、
    //  ユーザーがいなかったら匿名ログインを実装する

    useEffect(() {
      //何も返さないならなんでFUTUREをつかってる？
      //takuma:Futureを使って非同期処理を行うため。それと、awaitがあるからCALENDARPROVIDERの中身を取得するまで先に進まない。

      if (FirebaseAuth.instance.currentUser != null) {
          Future(() async{

          //CALENDARPROVIDERの中身を取得する
          await ref.read(calendarProvider).get();
          //カレンダースクリーンに飛ぶ
          unawaited(Navigator.of(context)
              .pushNamedAndRemoveUntil(CalendarScreen.id, (route) => false));
          });
          print('ユーザーの情報ゲット');
    }
      else {
        Future(() async {
            await FirebaseAuth.instance.signInAnonymously();
            unawaited(Navigator.of(context)
                //チュートリアルを行うページに遷移させたい　
                .pushNamedAndRemoveUntil(CalendarScreen.id, (route) => false));
        });
        print('匿名ログイン');
      }
      return null;
    }, const []);

    var deviceSize = MediaQuery.of(context).size;

    //処理中のUIを書いている
    return Scaffold(
      body: Center(
        // indicator変更
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //　LOADING文字出力
            Text('Loading',style: TextStyle(fontSize: deviceSize.height * 0.028,fontWeight: FontWeight.bold)),

            //...をタイプライターで表示する
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText('...',textStyle: TextStyle(fontSize: deviceSize.height * 0.028,fontWeight: FontWeight.bold),speed: Duration(milliseconds: 500)),
              ],
            ),

          ],
        ),
        ),
      );
  }
}
