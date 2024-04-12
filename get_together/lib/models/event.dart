// event.dart
class Event {
  final String date;
  final String eventType;
  final String info;
  final String location;
  final String name;
  final String photo;

  Event({
    required this.date,
    required this.eventType,
    required this.info,
    required this.location,
    required this.name,
    required this.photo,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      date: json['date'],
      eventType: json['event_type'],
      info: json['info'],
      location: json['location'],
      name: json['name'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'date': date,
    'event_type': eventType,
    'info': info,
    'location': location,
    'name': name,
    'photo': photo,
  };
}
}
