import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/calendar_model.dart';

//calendarスクリーンから追加、編集の時に持ってくる値をいい感じにする
class Arguments {
  final DateTime selectedDay;
  final bool isUpdate;
  final Map events;

  Arguments(this.selectedDay,this.isUpdate,this.events);
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
    final Arguments? arguments = ModalRoute.of(context)!.settings.arguments as Arguments?;

    //イベント追加用テキストコントローラー
    TextEditingController _eventController =
        TextEditingController(text: arguments!.events['title'] ?? '');

    //詳細用テキストコントローラー
    TextEditingController _detailEventController =
        TextEditingController(text: arguments.events['detail'] ?? '');

    //イベント追加した後にボタンだけで詳細入力できるようにするやつ
    final _detailFocusNode = FocusNode();


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("イベントを追加する"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.clear),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [

            //イベント追加用テキストフィールド
            TextFormField(
              controller: _eventController,
              autofocus: true,
              // onChanged: (text) {
              //   model.todoTitle = text;
              // },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
                hintText: 'イベント追加',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor
                  ),
                ),
              ),

              // 右下のボタンをNEXTにかえる
              textInputAction: TextInputAction.next,

              // NEXTを押したらパスワード入力フォームにフォーカスさせる
              onFieldSubmitted: (_) {
                FocusScope.of(context)
                    .requestFocus(_detailFocusNode); // 変更
              },

            ),

            SizedBox(
              height: 10,
            ),

            //詳細追加用テキストフィールド
            TextFormField(
              controller: _detailEventController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2.0,
                      color: Theme.of(context).primaryColor
                  ),
                ),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
                //focusColor: Colors.red,
                // labelText: '追加するイベントを入力してください',
                hintText: '詳細追加',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor
                  ),
                ),
              ),

              // パスワード入力フォームに飛ばせるたえのやつ
              focusNode: _detailFocusNode,
            ),

            SizedBox(
              height: 50,
            ),

            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                if (_eventController.text.isEmpty) {
                } else {
                  // isUpdateがtrueだったらupdateする
                  if( arguments.isUpdate ) {
                    //UPDATEする
                    ref
                        .read(calendarProvider)
                        .update(
                      arguments.events,
                      _eventController.text,
                      _detailEventController.text,
                    );
                  }else{
                    // isUpdateがfalseだったらpostする
                    //POSTする
                    ref
                        .read(calendarProvider)
                        .post(
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
              child: Text('追加',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
