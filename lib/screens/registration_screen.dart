import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/start_up.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../component/rounded_button.dart';
import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoad = false;
  String email = '';
  String password = '';

  Future<void> createUserFromEmail() async {
    setState(() {
      isLoad = true;
    });
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null) {
        Navigator.pushNamed(context, StartUpPage.id);
      }
      setState(() {
        isLoad = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('指定したメールアドレスは登録済みです');
      } else if (e.code == 'invalid-email') {
        print('メールアドレスのフォーマットが正しくありません');
      } else if (e.code == 'operation-not-allowed') {
        print('指定したメールアドレス・パスワードは現在使用できません');
      } else if (e.code == 'weak-password') {
        print('パスワードは６文字以上にしてください');
      }
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
        title: Text('登録'),
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
                    "ユーザー登録",
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
                    hintText: 'メールアドレスを入力してください',
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

                // ここからパスワード用のテキストフィールド
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
                        return 'パスワードは6文字以上でないといけません';
                      }
                      return null;
                    }),

                SizedBox(
                  height: 24.0,
                ),

                // 登録ボタン
                RoundedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  title: '登録',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      createUserFromEmail();
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
