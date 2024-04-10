import 'package:flutter/material.dart';
import 'event.dart'; 

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SizedBox(height: 25),
          event.photo.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(event.photo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : ClipRRect( 
                  borderRadius: BorderRadius.circular(15), 
                  child: Image.asset(
                    './lib/images/Arrows.png',
                    height: 300,
                    width: 300,
                  ),
                ),
          SizedBox(height: 25),
          Text(
            event.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("Type: ${event.eventType}"),
          Text("Location: ${event.location}"),
          Text("Info: ${event.info}"),
          if (event.date.isNotEmpty) Text("Date: ${event.date}"),
        ],
      ),
    );
  }
}
