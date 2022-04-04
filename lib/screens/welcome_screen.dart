import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/registration_screen.dart';
import '../component/rounded_button.dart';
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
            RoundedButton(
              textColor: Colors.white,
              color: Colors.blue,
              title: 'ログイン',
              onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
            ),

            // REGISTRATION
            RoundedButton(
              textColor: Colors.blue,
              color: Colors.blue[50],
              title: 'アカウントを作成する',
              onPressed: () => Navigator.pushNamed(context, RegistrationScreen.id),
            ),

          ],
        ),
      ),
    );
  }
}
