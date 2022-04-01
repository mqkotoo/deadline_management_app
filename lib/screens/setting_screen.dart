import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/welcome_screen.dart';

class SettingScreen extends StatelessWidget {
  static const String id = 'setting';
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
        actions: [

        ],
      ),
      body:ElevatedButton(
        child: Text('ログアウト'),
        onPressed: () {
          _auth.signOut();
          Navigator.pushNamed(context, WelcomeScreen.id);
          print("ログアウトしました");
        },
      ),
    );
  }
}