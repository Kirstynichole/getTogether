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
    String defaultPhoto = 'lib/images/placeholder.png';
    String photoUrl = json.containsKey('photo') && json['photo'] != null && json['photo'].toString().isNotEmpty 
                      ? json['photo'].toString()
                      : defaultPhoto;

    return Event(
      date: json['date'] ?? 'Date not provided',
      eventType: json['event_type'] ?? 'Unknown Type',
      info: json['info'] ?? 'No description available',
      location: json['location'] ?? 'Location not provided',
      name: json['name'] ?? 'Unnamed Event',
      photo: photoUrl,
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


//NYC.gov categories: ["Athletic", "Business & Finance", "City Government Office", "Cultural", "Education", "Environment", "Featured", "Free", "General Events", "Health & Public Safety", "Hearings and Meetings", "Holidays", "Kids and Family ", "Parks & Recreation", "Street and Neighborhood", "Tours", "Volunteer"]