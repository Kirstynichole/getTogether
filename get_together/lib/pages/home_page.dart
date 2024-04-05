import 'package:flutter/material.dart';
import 'package:get_together/components/event.dart';
import 'package:get_together/components/my_drawer.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'package:get_together/components/event_card.dart'; 
import 'package:get_together/services/event_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

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
