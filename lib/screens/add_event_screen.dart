import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/calendar_model.dart';

class AddEventScreen extends StatefulHookConsumerWidget {

  static const String id = 'add';

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends ConsumerState<AddEventScreen> {



  // late final List list;
  @override
  Widget build(BuildContext context) {

    //イベント追加用テキストコントローラー
    TextEditingController _eventController = TextEditingController();

    //イベント編集用テキストコントローラー
    // TextEditingController _editEventController = TextEditingController();

    //詳細用テキストコントローラー
    TextEditingController _detailEventController = TextEditingController();

    var selectedDay = ModalRoute.of(context)!.settings.arguments;


    return Scaffold(
      appBar: AppBar(
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
            ),

            SizedBox(
              height: 10,
            ),

            //詳細追加用テキストフィールド
            TextFormField(
              controller: _detailEventController,
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
                //focusColor: Colors.red,
                // labelText: '追加するイベントを入力してください',
                hintText: '詳細追加',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 50,
            ),

            TextButton(
              onPressed: () {
                if (_eventController.text.isEmpty) {
                } else {
                  //POSTする
                  ref
                      .read(calendarProvider)
                      .post(
                      selectedDay,
                      _eventController.text,
                      _detailEventController.text,
                  );
                }
                print(_eventController.text);
                Navigator.pop(context);
                _eventController.clear();

                //これ入れても入れなくても変わんない
                setState(() {});

                return;
              },
              child: Text('追加'),
            ),
            // RaisedButton(
            //   child: Text("追加"),
            //   onPressed: ()  {
            //
            //     // try {
            //     //   await model.addTodotoFirebase();
            //     //   await showDialog(
            //     //     context: context,
            //     //     builder: (BuildContext context) {
            //     //       return AlertDialog(
            //     //         title: Text('保存しました'),
            //     //         actions: [
            //     //           FlatButton(
            //     //             child: Text('OK'),
            //     //             onPressed: () {
            //     //               Navigator.of(context).pop();
            //     //             },
            //     //           ),
            //     //         ],
            //     //       );
            //     //     },
            //     //   );
            //     //   Navigator.of(context).pop();
            //     //   //ここから例外処理
            //     // } catch (e) {
            //     //   showDialog(
            //     //     context: context,
            //     //     builder: (BuildContext context) {
            //     //       return AlertDialog(
            //     //         title: Text(e.toString()),
            //     //         actions: [
            //     //           FlatButton(
            //     //             child: Text('OK'),
            //     //             onPressed: () {
            //     //               Navigator.of(context).pop();
            //     //             },
            //     //           ),
            //     //         ],
            //     //       );
            //     //     },
            //     //   );
            //     // }
            //     Navigator.pop(context);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
