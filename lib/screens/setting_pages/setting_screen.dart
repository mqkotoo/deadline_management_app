import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/calendar_screen.dart';
import 'package:flutter_deadline_management/screens/setting_pages/how_to_use/how_to_use.dart';
import 'package:flutter_deadline_management/screens/setting_pages/notification/notification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme/change_theme.dart';

class SettingScreen extends StatelessWidget {
  static const String id = 'setting';

  //プライバシーポリシーのURL
  final privacyPolicyUrl = 'https://qiita.com/mqkotoo/private/67e00cec34ce2ff84d63/';
  //お問い合わせ用TWITTERのURL
  final twitterUrl = 'https://twitter.com/Ldcax2BkFS3UuQW/';

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceSize.height * 0.064),
        child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Padding(
              padding: deviceSize.height > 900 ? EdgeInsets.only(top: 25.0) : EdgeInsets.only(),
              child: Text('設定',style: TextStyle(color: Theme.of(context).selectedRowColor,fontSize: deviceSize.height * 0.023)),
            ),
          leading: InkWell(
            // onTap: () => Navigator.pop(context),
            onTap: () => Navigator.pushNamedAndRemoveUntil(context,CalendarScreen.id, (_) => false),
            child: Padding(
              padding: deviceSize.height > 900 ? EdgeInsets.all(22) : EdgeInsets.only(),
              child: Icon(
                Icons.arrow_back_ios,
                    color: Theme.of(context).selectedRowColor,
                    size: deviceSize.height * 0.027,
                  ),
            ),
          ),

          ),
      ),
      body:  ListView(
          children: [
            _menuItem(context,title: "このアプリの使い方", onPress: () => Navigator.pushNamed(context, HowToUseScreen.id)),
            _menuItem(context,title: "テーマ着せ替え", onPress: () => Navigator.pushNamed(context, ChangeThemeScreen.id)),
            _menuItem(context,title: "通知", onPress: () => Navigator.pushNamed(context, SettingNotificationScreen.id)),
            _menuItem(context,title: "利用規約・プライバシーポリシー", onPress: () => _opnePrivacyPolicyUrl(privacyPolicyUrl)),
            _menuItem(context,title: "お問い合わせ", onPress: () => _opneInquiryUrl(twitterUrl)),
          ]
      ),
    );
  }


  Widget _menuItem(BuildContext context,
      {required String title, required void Function()? onPress}) {

    var deviceSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onPress,
      child:Container(
          padding: EdgeInsets.symmetric(vertical: deviceSize.width * 0.034),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
          ),
          child: Row(
            children: [
              SizedBox(
                width: deviceSize.width * 0.05,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: deviceSize.height * 0.02,
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                // padding: const EdgeInsets.fromLTRB(0,0,13,0),
                padding: EdgeInsets.only(right: deviceSize.width * 0.031),
                child: Icon(Icons.navigate_next,size: deviceSize.height * 0.03),
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
      enableJavaScript: true,
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
      enableJavaScript: true,
    );
  } else {
    throw 'このURLにはアクセスできません';
  }
}