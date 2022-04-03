//このページをFIRESTOREに対応させたEVENTモデルにする

class Event {
  final String title;
  final DateTime? date;

  Event({required this.title,this.date});

  String toString() => this.title;
}