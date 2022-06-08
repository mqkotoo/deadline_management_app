import 'package:flutter/material.dart';

class HowToUseScreen extends StatelessWidget {
  static const String id = 'howToUse';

  @override
  Widget build(BuildContext context) {

    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceSize.height * 0.064),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("アプリの使い方",
              style: TextStyle(color: Theme.of(context).selectedRowColor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).selectedRowColor,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _spaceS(context),
                  _titleText("1.タスク追加",context),
                  _spaceS(context),
                  _imageContainer(context, 'images/home_add.png'),
                  _spaceS(context),
                  _text("①からタスクを追加したい日付を選択し、②の＋ボタンを押す",context),
                  _spaceS(context),
                  _bottomArrow(context),
                  _spaceS(context),
                  _imageContainer(context, 'images/add_screen.png'),
                  _spaceS(context),
                  _text("③にタスク（必要なら詳細）を入力して、④で追加する",context),
                  _spaceL(context),
                  _titleText("2.タスクの編集",context),
                  _spaceS(context),
                  _imageContainer(context, 'images/home_edit.png'),
                  _spaceS(context),
                  _text("編集したい日付の①をタップする",context),
                  _spaceS(context),
                  _bottomArrow(context),
                  _spaceS(context),
                  _imageContainer(context, 'images/edit_screen.png'),
                  _spaceS(context),
                  _text("③で入力内容を編集し、④で変更を決定する",context),
                  _text("* ②でタスクを削除する",context),
                  _spaceL(context),
                  _titleText("3.着せ替えの実装",context),
                  _spaceS(context),
                  _imageContainer(context, 'images/change_color.png'),
                  _spaceS(context),
                  _text("設定 > テーマの着せ替え",context),
                  _text("①で着せ替えをしたい色を選び、②で変更を決定する",context),
                  _spaceL(context),
                  _titleText("4.通知の設定",context),
                  _spaceS(context),
                  _imageContainer(context, 'images/notification_on.png'),
                  _spaceS(context),
                  _text("設定 >  通知",context),
                  _text("①で通知のオンオフを設定する",context),
                  _text("通知をオンにしている場合には、②をタップすると通知を受け取る時間を指定することができる",context),
                  _spaceL(context),
                  _spaceS(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _imageContainer(context, String imagePath) {
    var deviceSize = MediaQuery.of(context).size;
    return Container(
      height: deviceSize.height * 0.7,
      decoration: BoxDecoration(
          //画像の外枠に黒線をつける
          border: Border.all(width: 1)),
      child: Image.asset(imagePath),
    );
  }

  Widget _spaceS(context) {
    var deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      height: deviceSize.height * 0.023,
    );
  }

  Widget _spaceL(context) {
    var deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      height: deviceSize.height * 0.046,
    );
  }


  Widget _text(String text,context) {
    var deviceSize = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: deviceSize.width * 0.041),
      ),
    );
  }

  Widget _titleText(String text,context) {
    var deviceSize = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: deviceSize.width * 0.06),
      ),
    );
  }

  Widget _bottomArrow(context) {
    var deviceSize = MediaQuery.of(context).size;
    return Text("↓",style: TextStyle(fontSize: deviceSize.height * 0.1));
  }

}
