import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/setting_pages/notification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'change_theme.dart';

class SettingScreen extends StatelessWidget {
  static const String id = 'setting';

  //プライバシーポリシーのURL
  final privacyPolicyUrl = 'https://qiita.com/mqkotoo/private/67e00cec34ce2ff84d63';
  //お問い合わせ用TWITTERのURL
  final twitterUrl = 'https://twitter.com/Ldcax2BkFS3UuQW';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('設定',style: TextStyle(color: Theme.of(context).selectedRowColor)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios,
            color: Theme.of(context).selectedRowColor,
          ),
        ),
        ),
      body:  ListView(
          children: [
            _menuItem(context,title: "このアプリの使い方", icon: Icon(Icons.navigate_next),onPress: () => print('onPressed')),
            _menuItem(context,title: "テーマ着せ替え", icon: Icon(Icons.navigate_next),onPress: () => Navigator.pushNamed(context, ChangeThemeScreen.id)),
            _menuItem(context,title: "通知", icon: Icon(Icons.navigate_next),onPress: () => Navigator.pushNamed(context, SettingNotificationScreen.id)),
            _menuItem(context,title: "利用規約・プライバシーポリシー", icon: Icon(Icons.navigate_next),onPress: () => _opnePrivacyPolicyUrl(privacyPolicyUrl)),
            _menuItem(context,title: "お問い合わせ", icon: Icon(Icons.navigate_next),onPress: () => _opneInquiryUrl(twitterUrl)),
          ]
      ),
    );
  }


  Widget _menuItem(BuildContext context,
      {required String title, required Icon icon,required void Function()? onPress}) {

    return GestureDetector(
      onTap: onPress,
      child:Container(
          padding: EdgeInsets.symmetric(vertical: 14.0),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
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
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,13,0),
                child: icon,
              ),
            ],
          )
      ),
    );
  }
}



//利用規約、プライバシーポリシーのURLに遷移させるやつ
Future _opnePrivacyPolicyUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
    );
  } else {
    throw 'このURLにはアクセスできません';
  }
}

//お問い合わせ（TWITTER）URLに遷移させるやつ
Future _opneInquiryUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
    );
  } else {
    throw 'このURLにはアクセスできません';
  }
}