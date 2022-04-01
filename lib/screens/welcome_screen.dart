import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/registration_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "締め切り管理アプリ（仮）",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 45.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 48.0,
            ),


            // LOGIN
            RaisedButton(
              child: Text(
                'ログイン',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              textColor: Colors.white,
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),

            // REGISTRATION
            RaisedButton(
                child: Text('アカウントを作成する',
                  style: TextStyle(fontWeight: FontWeight.bold),),
                textColor: Colors.blue,
                color: Colors.blue[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                // ボタンクリック後にアカウント作成用の画面の遷移する。
                onPressed: (){
                  Navigator.pushNamed(context, RegistrationScreen.id);
                }

            ),
          ],
        ),
      ),
    );
  }
}
