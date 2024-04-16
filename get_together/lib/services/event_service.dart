// event_service.dart

import 'package:get_together/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//parse Ticketmaster event JSON
Map<String, dynamic> parseTicketmasterEvent(Map<String, dynamic> json) {
  var images = json['images'] as List<dynamic>;
  String photoUrl = images.isNotEmpty ? images[0]['url'] : ""; //'./lib/images/placeholder.png';

  return {
    'name': json['name'],
    'date': json['dates']['start']['localDate'],
    'event_type': json['classifications'][0]['segment']['name'],
    'info': 'Tickets available on Ticketmaster', 
    'location': "${json['_embedded']['venues'][0]['city']['name']}, ${json['_embedded']['venues'][0]['state']['name']}",
    'photo': photoUrl,
  };
}

// Consolidated function to fetch all events from different sources
Future<List<Event>> fetchEvents() async {
  List<Event> allEvents = [];

  // Fetch local events
  allEvents.addAll(await fetchLocalEvents());

  // Fetch NYC.gov events
  // allEvents.addAll(await fetchNYCEvents());

  // Fetch Ticketmaster events
  allEvents.addAll(await fetchTicketmasterEvents());

  allEvents.shuffle();

  return allEvents;
}

// Fetch local events
Future<List<Event>> fetchLocalEvents() async {
  final urlLocal = Uri.parse('http://localhost:5555/events');
  final responseLocal = await http.get(urlLocal);
  if (responseLocal.statusCode == 200) {
    List<dynamic> localEventsJson = json.decode(responseLocal.body);
    return localEventsJson.map((json) => Event.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load local events');
  }
}

// Fetch NYC.gov events
// Future<List<Event>> fetchNYCEvents() async {
//   final urlNYC = Uri.parse("https://api.nyc.gov/calendar/search?startDate=04%2F19%2F2024%2012:00%20AM&endDate=12%2F30%2F2024%2012:00%20AM&sort=DATE");
//   final responseNYC = await http.get(urlNYC, headers: {
//     'Cache-Control': 'no-cache',
//     'Ocp-Apim-Subscription-Key': '',
//   });
//   if (responseNYC.statusCode == 200) {
//     final dataNYC = json.decode(responseNYC.body);
//     List<dynamic> nycEventsJson = dataNYC['items'];
//     return nycEventsJson.map((json) => Event.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load NYC.gov events: ${responseNYC.statusCode}');
//   }
// }

// Fetch Ticketmaster events (with unique names)
Future<List<Event>> fetchTicketmasterEvents() async {
  var url = Uri.parse("https://app.ticketmaster.com/discovery/v2/events.json?city=New+York&apikey=");
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    var eventsJson = json['_embedded']['events'] as List;
    var uniqueEvents = <String>{};
    var filteredEvents = eventsJson.where((event) {
      var eventName = event['name'] as String;
      if (!uniqueEvents.contains(eventName)) {
        uniqueEvents.add(eventName);
        return true;
      }
      return false;
    }).map((jsonEvent) => Event.fromJson(parseTicketmasterEvent(jsonEvent))).toList();
    
    return filteredEvents;
  } else {
    throw Exception('Failed to load Ticketmaster events');
  }
}


// event_service.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get_together/models/event.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';


// Future<List<Event>> fetchEvents() async {
//   final url = Uri.parse('http://localhost:5555/events');
//   final response = await http.get(url);

//   if (response.statusCode == 200) {
//     List jsonResponse = json.decode(response.body);
//     return jsonResponse.map((data) => Event.fromJson(data)).toList();
//   } else {
//     throw Exception('Failed to load events');
//   }

  
// }

