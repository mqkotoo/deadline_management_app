import 'package:flutter/material.dart';

class AddEventScreen extends StatelessWidget {

  static const String id = 'add';

  // late final List list;

  @override
  Widget build(BuildContext context) {
    // final bool isUpdate = list != null;

    return Scaffold(
      appBar: AppBar(
        title: Text("イベントを追加する"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            TextFormField(
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


            TextFormField(
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
            RaisedButton(
              child: Text("追加"),
              onPressed: ()  {

                // try {
                //   await model.addTodotoFirebase();
                //   await showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         title: Text('保存しました'),
                //         actions: [
                //           FlatButton(
                //             child: Text('OK'),
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //           ),
                //         ],
                //       );
                //     },
                //   );
                //   Navigator.of(context).pop();
                //   //ここから例外処理
                // } catch (e) {
                //   showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         title: Text(e.toString()),
                //         actions: [
                //           FlatButton(
                //             child: Text('OK'),
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //           ),
                //         ],
                //       );
                //     },
                //   );
                // }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
