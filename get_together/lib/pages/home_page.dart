import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'package:flutter/material.dart';
import 'package:get_together/models/event.dart';
import 'package:get_together/components/my_drawer.dart';
import 'package:get_together/components/event_card.dart';
import 'package:get_together/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Event>> futureEvents;
  bool _noMoreEvents = false; //manage the display state


  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();
  }

  void _addInterest(Event event) async {
    final user = widget._auth.currentUser;
    if (user != null) {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final eventMap = event.toJson();
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userDocRef);
        if (userSnapshot.exists) {
          final List<dynamic> currentInterests =
              userSnapshot.data()?['interests'] as List<dynamic>? ?? [];
          if (!currentInterests
              .any((element) => element['name'] == event.name)) {
            transaction.update(userDocRef, {
              'interests': FieldValue.arrayUnion([eventMap])
            });
          }
        } else {
          // If there are no interests array, create one and add the event.
          transaction.set(userDocRef, {
            'interests': [eventMap]
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    SwipeableCardSectionController _cardController = SwipeableCardSectionController();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 212, 240, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 212, 240, 1),
      ),
      drawer: const MyDrawer(),
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
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
                  items: events.map((event) => EventCard(event: event)).toList(),
                  onCardSwiped: (dir, index, widget) {
                    if (dir == Direction.right) {
                      _addInterest(widget.event);
                    }
                    // Check if this is the last card
                    if (index == events.length - 1) {
                      setState(() {
                        _noMoreEvents = true;
                      });
                    } else {
                      // Add a new card only if the index is within the range
                      if (index + 1 < events.length) {
                        _cardController.addItem(EventCard(event: events[index + 1]));
                      }
                    }
                  },

                  enableSwipeUp: true,
                  enableSwipeDown: false,
                ),
                if (_noMoreEvents)
                  const Padding(
                    padding: EdgeInsets.only(right:8.0, left: 8, bottom: 20),
                    child: Text("No more events to display!"),
                  ),
              ],
            );
          } else {
            return const Text("No events found");
          }
        },
      ),
    );
  }
}
