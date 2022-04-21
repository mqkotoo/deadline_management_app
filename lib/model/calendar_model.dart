//モデルの作成
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deadline_management/model/fireauth.dart';
import 'package:flutter_deadline_management/model/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final calendarProvider = Provider((ref) => CalendarModel(ref.read));

//storeProviderはFirestoreの
class CalendarModel {
  CalendarModel(this._read);
  final Reader _read;
  List eventsList = [];

  //以下追加処理
  Future get() async {
    final store = _read(storeProvider);
    //  authのcurrentUserを使える
    final uid = _read(authProvider).currentUser!.uid;

    //STOREに追加処理
    final db = await store
        .collection("AppPackage")
        .doc("v1")
        .collection("users")
        .doc(uid)
        .get();

    //ここ質問する、EVENTSはどうやって生成してる？この下の一行でいい感じに行けるのか？
    //過去のコード(現在変更済み)
    // eventsList = db.data()?['events'] ?? [];
    // print(eventsList);

    //takuma:ここでは、DBにデータが存在したらそれをeventsListに入れて、なかったら空を入れています。
    // if (db.exists != null) {
    if (db.data()?['events'] != null) {
      eventsList = db.data()?['events'];
      print(eventsList);
    } else {
      eventsList = [];
      print(eventsList);
    }
  }

  //以下投稿処理
  Future post(date, title, description) async {
    final store = _read(storeProvider);
    final uid = _read(authProvider).currentUser!.uid;

    // db指定
    final db = await store
        .collection("AppPackage")
        .doc("v1")
        .collection("users")
        .doc(uid);

    //POSTの形を作る
    final post = {
      "at": Timestamp.fromDate(date),
      "title": title,
      "detail": description,
    };

    // 追加処理
    eventsList.add(post);

    //もし、Firestoreの方に値がなければsetしてくれる。
    //すでにFirestoreの方に値が存在していたらupdateをしてくれる。
    await db.set({
      "events" : eventsList,
    }, SetOptions(merge: true));
  }

  //以下更新処理
  //final うえ = {
  //       "at": 4月18日,
  //       "title": "a",
  //       "detail": "詳細",
  //     };
  //final した = {
  //       "at": 4月18日,
  //       "title": "a",
  //       "detail": "詳細",
  //     };
  //title = a

  Future update(event, title, description) async {
    final store = _read(storeProvider);
    final uid = _read(authProvider).currentUser!.uid;

    // db指定
    final db = await store
        .collection("AppPackage")
        .doc("v1")
        .collection("users")
        .doc(uid);

    //POSTの形を作る
    //編集後の値
    final post = {
      "at": event["at"],
      "title": title,
      "detail": description,
    };

    // 選択していた値(もう使わない)をリストから削除
    eventsList.remove(event);
    //List iroiro = ["apple","cat"]
    //iroiro.remove("apple");

    // そのかわりに編集後の値をリストに追加
    eventsList.add(post);

    // 更新処理
    await db.update({
      "events": eventsList,
    });
  }

  //以下削除処理
  Future delete(event) async {
    final store = _read(storeProvider);
    final uid = _read(authProvider).currentUser!.uid;

    // db指定
    final db = await store
        .collection("AppPackage")
        .doc("v1")
        .collection("users")
        .doc(uid);

    // 削除処理
    eventsList.remove(event);

    /*
    eventsList = [
      {"at":"2022-04-20","title":"google","detail":"詳細"},
      {"at":"2022-04-19","title":"yahoo","detail":"詳細"}
    ]
     */
    //これはなんのUPDATE??
    //takuma:delete機能はまだ未実装
    //2022/04/20夜までに作成します
    await db.update({
      "events": eventsList,
    });
  }
}
