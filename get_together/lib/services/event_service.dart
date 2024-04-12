// event_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_together/models/event.dart';
import 'package:get_together/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<List<Event>> fetchEvents() async {
  final url = Uri.parse('http://localhost:5555/events');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Event.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load events');
  }

  
}


