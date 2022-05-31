import 'package:flutter/material.dart';

class HowToUseScreen extends StatelessWidget {
  static const String id = 'howToUse';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _spaceS(),
                  _titleText("1.タスク追加"),
                  _spaceS(),
                  _imageContainer(context, 'images/home_add.png'),
                  _spaceS(),
                  _text("①からタスクを追加したい日付を選択し、②の＋ボタンを押す"),
                  _spaceS(),
                  _bottomArrow(),
                  _spaceS(),
                  _imageContainer(context, 'images/add_screen.png'),
                  _spaceS(),
                  _text("③にタスク（必要なら詳細）を入力して、④で追加する"),
                  _spaceL(),
                  _titleText("2.タスクの編集"),
                  _spaceS(),
                  _imageContainer(context, 'images/home_edit.png'),
                  _spaceS(),
                  _text("編集したい日付の①をタップする"),
                  _spaceS(),
                  _bottomArrow(),
                  _spaceS(),
                  _imageContainer(context, 'images/edit_screen.png'),
                  _spaceS(),
                  _text("③で入力内容を編集し、④で変更を決定する"),
                  _text("* ②でタスクを削除する"),
                  _spaceL(),
                  _titleText("3.着せ替えの実装"),
                  _spaceS(),
                  _imageContainer(context, 'images/change_color.png'),
                  _spaceS(),
                  _text("設定 > テーマの着せ替え"),
                  _text("①で着せ替えをしたい色を選び、②で変更を決定する"),
                  _spaceL(),
                  _titleText("4.通知の設定"),
                  _spaceS(),
                  _imageContainer(context, 'images/notification_on.png'),
                  _spaceS(),
                  _text("①で通知のオンオフを設定する"),
                  _text("通知をオンにしている場合には、②をタップすると通知を受け取る時間を指定することができる"),
                  _spaceL(),
                  _spaceL(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _imageContainer(context, String imagePath) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
          //画像の外枠に黒線をつける
          border: Border.all(width: 1)),
      child: Image.asset(imagePath),
    );
  }

  Widget _spaceS() {
    return SizedBox(
      height: 20,
    );
  }

  Widget _spaceL() {
    return SizedBox(
      height: 40,
    );
  }

  Widget _lineSpace() {
    return SizedBox(
      height: 5,
    );
  }



  Widget _text(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
    );
  }

  Widget _titleText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: 25),
      ),
    );
  }

  Widget _bottomArrow() {
    return Text("↓",style: TextStyle(fontSize: 40));
  }

}
