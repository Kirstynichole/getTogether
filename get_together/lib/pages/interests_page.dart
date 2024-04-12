import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_together/models/event.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map> _interestsList = [];

Future<List<Event>> fetchInterests() async {
    final user = _auth.currentUser;
    List<Event> eventsList = [];
    if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (docSnapshot.exists) {
            final List<dynamic> interests = docSnapshot.data()?['interests'] as List<dynamic>? ?? [];
            eventsList = interests.map((e) => Event.fromJson(Map<String, dynamic>.from(e))).toList();
        }
    }
    return eventsList;
}

@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interests"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        ),
        body: FutureBuilder<List<Event>>(
            future: fetchInterests(),
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                    List<Event> events = snapshot.data!;
                    if (events.isEmpty) {
                        return Center(child: Text("No interests found"));
                    }
                    return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                            Event event = events[index];
                            return ListTile(
                                title: Text(event.name),
                                subtitle: Text(event.location),
                            );
                        },
                    );
                } else {
                    return Center(child: Text("No interests found"));
                }
            }
        ),
    );
}
}

