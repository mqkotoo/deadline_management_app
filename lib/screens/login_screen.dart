import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../component/rounded_button.dart';
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

    final newUser = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    setState(() {
      isLoad = true;
    });

    try {
      // ユーザが確認できたら
      if (newUser != null) {
        Navigator.pushNamed(context, CalendarScreen.id);
        print("ログインに成功しました");
      }
      // ユーザがいなかったら

      setState(() {
        isLoad = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    // 入力処理の時に使う奴ら
    final _passwordFocusNode = FocusNode();
    final _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
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

                // メールアドレスの入力フォーム
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    //Do something with the user input.
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'メールアドレスを入力して下さい',
                  ),

                  // 右下のボタンをNEXTにかえる
                  textInputAction: TextInputAction.next,

                  // NEXTを押したらパスワード入力フォームにフォーカスさせる
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode); // 変更
                  },

//                  バリデーション実装
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'メールアドレスを入力してください';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),

                // パスワードの入力フォーム
                TextFormField(
                  obscureText: true,
                  onChanged: (value) {
                    //Do something with the user input.
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'パスワードを入力してください',
                  ),

                  // パスワード入力フォームに飛ばせるたえのやつ
                  focusNode: _passwordFocusNode,

                    //バリデーション実装
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'パスワードを入力してください';
                      }
                      if (value.length < 6) {
                        return 'パスワードは6文字以上です';
                      }
                      return null;
                    }

                ),
                SizedBox(
                  height: 24.0,
                ),

                // ログインボタン
                RoundedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  title: 'ログイン',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginUserFromEmail();
                    }
                    print(email);
                    print(password);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}