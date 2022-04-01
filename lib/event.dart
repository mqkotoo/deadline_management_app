//このページをFIRESTOREに対応させたEVENTモデルにする

// class Event {
//   final String title;
//
//   Event({required this.title});
//
//   String toString() => this.title;
// }

class Event {
  final String title;
  // final DateTime date;

  // Event({required this.title, this.date});
  Event({required this.title});

  String toString() => this.title;
// DateTime toDateTime() => this.date;

}