import 'package:flutter/material.dart';
import 'package:get_together/models/event.dart';
import 'package:get_together/components/my_drawer.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'package:get_together/components/event_card.dart'; 
import 'package:get_together/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Event>> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();
  }

void _addInterest(Event event) async {
  final user = widget._auth.currentUser;
  if (user != null) {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final eventMap = event.toJson();
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userDocRef);
      if (userSnapshot.exists) {
        final List<dynamic> currentInterests = userSnapshot.data()?['interests'] as List<dynamic>? ?? [];
        // Check for the event's uniqueness based on a unique identifier, like its name or an ID
        if (!currentInterests.any((element) => element['name'] == event.name)) {
          transaction.update(userDocRef, {'interests': FieldValue.arrayUnion([eventMap])});
        }
      } else {
        // If there are no interests array, create one and add the event.
        transaction.set(userDocRef, {'interests': [eventMap]});
      }
    });
  }
}

  @override
  Widget build(BuildContext context) {
    SwipeableCardSectionController _cardController = SwipeableCardSectionController();

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 212, 240, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 212, 240, 1),
      //   title: Text("Home"),
        
      ),
      drawer: MyDrawer(),
      // Text("Hello ${User.name}")
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            List<Event> events = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  './lib/images/Swipe.png',
                  width: 500,
                  height: 125,
                  ),
                SwipeableCardsSection(
                  cardController: _cardController,
                  context: context,
                  items: events.take(3).map((event) => EventCard(event: event)).toList(),
                  onCardSwiped: (dir, index, widget) {
                    
                    // Check if there are more events to display
                    if (events.length > index + 1) {
                      // Add the next event card
                      _cardController.addItem(EventCard(event: events[index + 1]));
                    }
                    if (dir == Direction.right) {
                      _addInterest(events[index]);
                    }
                  },
                  
                  enableSwipeUp: true,
                  enableSwipeDown: false,
                ),
              ],
            );
          } else {
            return Text("No events found");
          }
        },
      ),
    );
  }
}
