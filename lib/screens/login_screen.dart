import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants.dart';
import 'calendar_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoad = false;
  late String email;
  late String password;

  Future<void> loginUserFromEmail() async {
    setState(() {
      isLoad = true;
    });
    try {
      final newUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null) {
        Navigator.pushNamed(context, CalendarScreen.id);
        print("ログインに成功しました");
      }
      setState(() {
        isLoad = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ログイン',
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoad,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Text("ログイン↓↓",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'メールアドレスを入力して下さい',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'パスワードを入力してください',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),

              // ログインボタン
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
                  loginUserFromEmail();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}