//モデルの作成
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deadline_management/model/fireauth.dart';
import 'package:flutter_deadline_management/model/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final calendarProvider = Provider((ref) => CalendarModel(ref.read));

class EventModel {
  EventModel(this.date, this.event);
  String date;
  List event;
}

class EventList {
  EventList(this.at, this.eventTitle, this.description);
  DateTime at;
  String eventTitle;
  String description;
}

//storeProviderはFirestoreの
class CalendarModel {
  CalendarModel(this._read);
  final Reader _read;
  List eventsList = [];

  //以下追加処理
  Future get() async {
    final store = _read(storeProvider);
    final uid = _read(authProvider).currentUser!.uid;
    final db = await store
        .collection("AppPackage")
        .doc("v1")
        .collection("users")
        .doc(uid)
        .get();
    eventsList = db.data()?['events'] ?? [];
    print(eventsList);
  }

  //以下投稿処理
  Future post(date, title, description) async {
    final store = _read(storeProvider);
    final uid = _read(authProvider).currentUser!.uid;
    final db = await store
        .collection("AppPackage")
        .doc("v1")
        .collection("users")
        .doc(uid);
    final post = {
      "at": Timestamp.fromDate(date),
      "title": title,
      "detail": description,
    };
    eventsList.add(post);
    await db.update({
      "events": eventsList,
    });
  }

  //以下削除処理
  Future delete(date, event) async {
    final store = _read(storeProvider);
    final db = store.collection("AppPackage").doc("v1");
    eventsList[date]!.remove(event);
    await db.update({
      "events": eventsList,
    });
  }
}
