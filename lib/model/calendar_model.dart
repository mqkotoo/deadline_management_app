//モデルの作成
class EventModel{
  EventModel(this.date,this.event);
  String date;
  List event;
}


//storeProviderはFirestoreの
class CalendarModel{
  CalendarModel(this._read);
  final Reader _read;
  //とってきた値を入れる
  Map? event;
  //mapから変換
  late List event_list;
  //さらに型変換
  Map<DateTime, List?> eventsList = {};

  //以下追加処理
  Future get()async{
    final store = _read(storeProvider);
    final db = await store.collection("AppPackage").doc("v1").get();
    event = db.data()!["event"];
    event_list = event!.entries.map((e) => EventModel(e.key, e.value)).toList();
    for(int i = 0;i<event_list.length;i++){
      final map = <DateTime,List?>{
        DateTime.parse(event_list[i].date):event_list[i].event
      };
      eventsList.addAll(map);
    }
  }

  //以下投稿処理
  Future post(date,title,detail)async{
    final store = _read(storeProvider);
    final db = store.collection("AppPackage").doc("v1");
    event!.addAll(<String,List<dynamic>>{
      date:[title,detail]
    });
    await db.update({
      "event":event,
    });
    event_list = event!.entries.map((e) => EventModel(e.key, e.value)).toList();
    final map = <DateTime,List?>{
      DateTime.parse(event_list.last.date):event_list.last.event
    };
    eventsList.addAll(map);
  }

  //以下削除処理
  Future delete(String date)async{
    final store = _read(storeProvider);
    final db = store.collection("AppPackage").doc("v1");
    event!.remove(date);
    await db.update({
      "event":event,
    });
    event_list = event!.entries.map((e) => EventModel(e.key, e.value)).toList();
    eventsList.remove(DateTime.parse(date));
  }
}