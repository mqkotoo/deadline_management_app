import 'package:flutter/material.dart';
import 'package:flutter_deadline_management/screens/calendar_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../ads/adBanner.dart';
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

  final TextEditingController _eventController = TextEditingController();

  final TextEditingController _detailEventController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    //argumentsのなかにline7で作った形式で値を扱えるようになった
    final Arguments? arguments =
        ModalRoute.of(context)!.settings.arguments as Arguments?;
    
    useEffect(() {
      _eventController.text = arguments!.events['title'] ?? '';
      _detailEventController.text = arguments.events['detail'] ?? '';
      return null;
    },const []);


    var deviceSize = MediaQuery.of(context).size;


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceSize.height * 0.064),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Padding(
            padding: deviceSize.height > 900 ? EdgeInsets.only(top:25.0) : EdgeInsets.only(),
            child: Text(
              //編集か追加でボタンのテキストを変える
              arguments!.isUpdate ? 'タスクを編集する' : 'タスクを追加する',
              style: TextStyle(color: Theme.of(context).selectedRowColor,fontSize: deviceSize.height * 0.023),
            ),
          ),
          leading: IconButton(
            //calendarページのisAddにfalseを返している
            onPressed: () => Navigator.pop(context,false),
            icon: Icon(
                Icons.clear,
                //28↓
                size: deviceSize.height * 0.04,
                color: Theme.of(context).selectedRowColor,
            ),
          ),
          actions: [
            Visibility(
              //編集時はアップバーの右上に削除ボタンを設ける
              visible: arguments.isUpdate,
              child: Padding(
                padding: EdgeInsets.only(right: deviceSize.width * 0.01),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      // barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                        buttonPadding: EdgeInsets.fromLTRB(
                            0,
                          0,
                          deviceSize.width * 0.085,
                          deviceSize.height * 0.023,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(
                            // 24.0,
                          deviceSize.width * 0.085,
                          deviceSize.height * 0.023,
                          deviceSize.width * 0.085,
                          // deviceSize.height * 0.023,
                          0,
                        ),
                        titlePadding: EdgeInsets.fromLTRB(
                          deviceSize.width * 0.085,
                          deviceSize.height * 0.023,
                          deviceSize.width * 0.085,
                          deviceSize.height * 0.023,
                        ),

                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        title: Text(
                            "タスク削除",
                            style: TextStyle(fontSize: deviceSize.height * 0.024),
                        ),
                        content: Container(
                          width: deviceSize.width * 0.6,
                          height : deviceSize.height * 0.05,
                          child: Text(
                              '"${arguments.events['title']}"を削除しますか？',
                              style: TextStyle(fontSize: deviceSize.height * 0.018),
                          ),
                        ),
                        actions: [
                          // キャンセルボタン

                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'キャンセル',
                              style: TextStyle(fontSize: deviceSize.height * 0.02),
                            ),
                          ),
                          // OKボタン
                          TextButton(
                            onPressed: () async {
                              await ref
                                  .read(calendarProvider)
                                  .delete(arguments.events);
                              // Navigator.pop(context);
                              //カレンダー画面まで一気にポップする
                              Navigator.popUntil(
                                  context, ModalRoute.withName(CalendarScreen.id));

                              // 更新する
                              setState(() {});
                            },
                            child: Text(
                                '削除',
                                style: TextStyle(fontSize: deviceSize.height * 0.02,color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                      Icons.delete_outline,
                      //28↓
                      size: deviceSize.height * 0.04,
                      color: Theme.of(context).selectedRowColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  //40↓
                  padding: EdgeInsets.all(deviceSize.height * 0.046),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            //テーマによってラベルテキストの色を変える
                            color: Theme.of(context).disabledColor),
                        // alignment: Alignment.centerLeft,
                        width: deviceSize.width,
                        //55↓
                        height: deviceSize.height * 0.061,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //カレンダーアイコン
                              Icon(
                                // color: Colors.white,
                                Icons.calendar_month,
                                //40↓
                                size: deviceSize.height * 0.046,
                                color: Colors.white,
                              ),
                              //アイコンとテキストのスペース調節
                              //17↓
                              SizedBox(width: deviceSize.width * 0.036),
                              //選択している日付
                              Text(
                                DateFormat.MMMEd('ja').format(arguments.selectedDay),
                                style: TextStyle(
                                  // 17↓
                                  fontSize: deviceSize.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        // 40↓
                        height: deviceSize.height * 0.046,
                      ),

                      //締め切り追加用テキストフィールド
                      TextFormField(
                        style: TextStyle(fontSize: deviceSize.height * 0.016),
                        controller: _eventController,
                        // autofocus: true,
                        decoration: InputDecoration(
                          //通常の時のフォームのスタイル
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Theme.of(context).disabledColor),
                              borderRadius: BorderRadius.circular(8),
                          ),
                          //focusした時のフォームのスタイル
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0, color: Theme.of(context).disabledColor),
                              borderRadius: BorderRadius.circular(8)),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              //テーマによってラベルテキストの色を変える
                              color: Theme.of(context).bottomAppBarColor,
                          ),

                          //編集か追加でヒント、ラベルテキストを変える
                          labelText: arguments.isUpdate ? 'タスク変更' : 'タスク追加',
                          hintText: arguments.isUpdate ? null : '（必須）読書感想文',

                          //ラベルテキスト枠の上に固定する
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),

                        //  キーパッドの左下の「確定」→「次へ」みたいにする
                        textInputAction: TextInputAction.next,

                      ),

                      SizedBox(
                        // 17↓
                        height: deviceSize.height * 0.017,
                      ),

                      //詳細追加用テキストフィールド
                      TextFormField(
                        style: TextStyle(fontSize: deviceSize.height * 0.016),
                        maxLines: 5,
                        controller: _detailEventController,
                        decoration: InputDecoration(
                          //通常時のフォームのスタイル
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Theme.of(context).disabledColor),
                              borderRadius: BorderRadius.circular(8)),
                          //focusした時のフォームのスタイル
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0, color: Theme.of(context).disabledColor),
                              borderRadius: BorderRadius.circular(8)),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              //テーマによってラベルテキストの色を変える
                              color: Theme.of(context).bottomAppBarColor,
                          ),

                          //編集か追加でヒント,ラベルテキストを変える
                          labelText: arguments.isUpdate ? '詳細の変更' : '詳細の追加',
                          hintText: arguments.isUpdate
                              ? null
                              : '（任意）\n原稿用紙2枚以上\n体育が終わったら〇〇先生に提出する\n14:30まで',

                          //ラベルテキスト枠の上に固定する
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),

                        // //  詳細入力フォームにフォーカスを移すためにここの入力フォームにFOCUSNODEを設定してあげる
                        // focusNode: _detailFocusNode,
                      ),

                      SizedBox(
                        //50↓
                        height: deviceSize.height * 0.058,
                      ),

                      SizedBox(
                        //85↓
                        width: deviceSize.height * 0.1,
                        //40↓
                        height: deviceSize.height * 0.046,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              //テーマによってbuttonの色を変える
                              backgroundColor: Theme.of(context).disabledColor,
                              elevation: 10,
                          ),
                          onPressed: () {
                            if (_eventController.text.isEmpty) {
                              return;
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
                            //calendarページのisAddにTRUEを返している
                            Navigator.pop(context,true);
                            _eventController.clear();

                            return;
                          },
                          child: Text(
                            //編集か追加でボタンのテキストを変える
                            arguments.isUpdate ? '変更' : '追加',
                            style: TextStyle(
                                color: Colors.white,
                                //16↓
                                fontSize: deviceSize.height * 0.018,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
              SizedBox(
                width: deviceSize.width,
                height: deviceSize.height*0.08,
                child: AdBanner(),
              ),
              SizedBox(height: deviceSize.height * 0.04),
          ],
        ),
      ),
    );
  }
}
