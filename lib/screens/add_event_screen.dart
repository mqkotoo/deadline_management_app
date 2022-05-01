import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../model/calendar_model.dart';

//calendarスクリーンから追加、編集の時に持ってくる値をいい感じにする
class Arguments {
  final DateTime selectedDay;
  final bool isUpdate;
  final Map events;

  Arguments(this.selectedDay, this.isUpdate, this.events);
}

class AddEventScreen extends StatefulHookConsumerWidget {
  static const String id = 'add';

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends ConsumerState<AddEventScreen> {
  // late final List list;
  @override
  Widget build(BuildContext context) {
    //argumentsのなかにline7で作った形式で値を扱えるようになった
    final Arguments? arguments =
        ModalRoute.of(context)!.settings.arguments as Arguments?;

    //イベント追加用テキストコントローラー
    TextEditingController _eventController =
        TextEditingController(text: arguments!.events['title'] ?? '');

    //詳細用テキストコントローラー
    TextEditingController _detailEventController =
        TextEditingController(text: arguments.events['detail'] ?? '');

    //イベント追加した後にボタンだけで詳細追加のところにフォーカスできるようにするやつ
    final _detailFocusNode = FocusNode();

    //テーマ別に色を変えられるようにするためのやつ
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    //２画面画面をポップするために使うやつ
    int count = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          //編集か追加でボタンのテキストを変える
          arguments.isUpdate ? '締め切りを編集する' : '締め切りを追加する',
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.clear),
        ),
        actions: [
          Visibility(
            visible: arguments.isUpdate,
            child: IconButton(
                onPressed: () {
                  showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("タスク削除"),
                                  content: Text(
                                      '"${arguments.events['title']}"を削除しますか？'),
                                  actions: [
                                    // キャンセルボタン
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: Text('キャンセル'),
                                    ),
                                    // OKボタン
                                    TextButton(
                                      onPressed: () async {
                                        await ref
                                            .read(calendarProvider)
                                            .delete(arguments.events);
                                        // Navigator.pop(context);
                                        //カレンダー画面まで一気に二つ分ポップする
                                        Navigator.popUntil(context, (_) => count++ >= 2);

                                        // 更新する
                                        setState(() {});
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                },
                icon: Icon(Icons.delete,size: 28),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                    //テーマによってラベルテキストの色を変える
                    color: Theme.of(context).primaryColor
                ),
                // alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                height: 54.78,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //カレンダーアイコン
                      Icon(
                        // color: Colors.white,
                        Icons.calendar_month,
                        size: 40,
                        color: Colors.white,
                      ),
                      //アイコンとテキストのスペース調節
                      SizedBox(width: 15),
                      //選択している日付
                      Text(
                        DateFormat.MMMEd('ja').format(arguments.selectedDay),
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 40,
              ),

              //締め切り追加用テキストフィールド
              TextFormField(
                controller: _eventController,
                // autofocus: true,
                decoration: InputDecoration(
                  //通常の時のフォームのスタイル
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  //focusした時のフォームのスタイル
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2.0, color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      //テーマによってラベルテキストの色を変える
                      color: platformBrightness == Brightness.dark
                          ? Colors.white
                          :Colors.pink[400]
                  ),

                  //編集か追加でヒント、ラベルテキストを変える
                  labelText: arguments.isUpdate ? '締め切り変更' : '締め切り追加',
                  hintText: arguments.isUpdate ? null : '（必須）読書感想文',

                  //ラベルテキスト枠の上に固定する
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),

                //  キーパッドの左下の「確定」→「次へ」みたいにする
                textInputAction: TextInputAction.next,

                //  次へ　を押したら詳細入力フォームにフォーカスを移すようにする
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_detailFocusNode);
                },
              ),

              SizedBox(
                height: 15,
              ),

              //詳細追加用テキストフィールド
              TextFormField(
                maxLines: 5,
                controller: _detailEventController,
                decoration: InputDecoration(
                  //通常時のフォームのスタイル
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  //focusした時のフォームのスタイル
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2.0, color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      //テーマによってラベルテキストの色を変える
                      color: platformBrightness == Brightness.dark
                          ? Colors.white
                          :Colors.pink[400]
                  ),

                  //編集か追加でヒント,ラベルテキストを変える
                  labelText: arguments.isUpdate ? '詳細の変更' : '詳細の追加',
                  hintText:
                      arguments.isUpdate ? null : '（任意）\n原稿用紙2枚以上\n体育が終わったら〇〇先生に提出する',

                  //ラベルテキスト枠の上に固定する
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),

                //  詳細入力フォームにフォーカスを移すためにここの入力フォームにFOCUSNODEを設定してあげる
                focusNode: _detailFocusNode,
              ),

              SizedBox(
                height: 50,
              ),

              SizedBox(
                width: 85,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    //テーマによってbuttonの色を変える
                      backgroundColor: platformBrightness == Brightness.dark
                          ? Colors.indigo
                          :Theme.of(context).primaryColor
                  ),
                  onPressed: () {
                    if (_eventController.text.isEmpty) {
                    } else {
                      // isUpdateがtrueだったらupdateする
                      if (arguments.isUpdate) {
                        //UPDATEする
                        ref.read(calendarProvider).update(
                              arguments.events,
                              _eventController.text,
                              _detailEventController.text,
                            );
                      } else {
                        // isUpdateがfalseだったらpostする
                        //POSTする
                        ref.read(calendarProvider).post(
                              arguments.selectedDay,
                              _eventController.text,
                              _detailEventController.text,
                            );
                      }
                    }
                    print(_eventController.text);
                    Navigator.pop(context);
                    _eventController.clear();

                    return;
                  },
                  child: Text(
                    //編集か追加でボタンのテキストを変える
                    arguments.isUpdate ? '変更' : '追加',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
