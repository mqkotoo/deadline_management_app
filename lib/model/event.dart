//このページをFIRESTOREに対応させたEVENTモデルにする

class Event {
  final String title;
  final DateTime? date;

  Event({required this.title, this.date});

  String toString() => this.title;

  Map<String, dynamic> toMap() {
    return {
      'eventTitle': title,
      'eventDate': date,
    };
  }

  Event.fromFirestore(Map<String, dynamic> firestore)
      : title = firestore['eventTitle'],
        date = firestore['eventDate'].toDate();
}