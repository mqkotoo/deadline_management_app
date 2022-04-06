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
  String email = '';
  String password = '';
  // firebaseからのエラーメッセージを表示するための変数
  String errorMessage = '';

  Future<void> loginUserFromEmail() async {
    setState(() {
      isLoad = true;
    });

    try {
      // newUserに値を入れる
      final newUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // ユーザが確認できたら
      if (newUser != null) {

        // 全画面ポップしてCALENDAR画面を表示する(カレンダーページだけがスタックに存在する
        Navigator.of(context)
            .pushNamedAndRemoveUntil(CalendarScreen.id, (route) => false);

        print("ログインに成功しました");
      }
      setState(() {
        isLoad = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        errorMessage = 'そのメールアドレスは利用できません';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'メールアドレスのフォーマットが正しくありません';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'ユーザーが見つかりません';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'パスワードが違います';
      }
      // setState(() {});
    }
    // エラー後にロードを解除する
    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 入力処理の時に使う奴ら
    final _passwordFocusNode = FocusNode();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'ログイン',
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
                  child: Text(
                    "ログイン↓↓",
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
                    FocusScope.of(context)
                        .requestFocus(_passwordFocusNode); // 変更
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
                    }),
                SizedBox(
                  height: 8.0,
                ),

                // FIREBASEからのエラー表示
                Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.red,
                    ),
                  ),
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
