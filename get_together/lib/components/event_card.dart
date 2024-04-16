import 'package:flutter/material.dart';
import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  ImageProvider<Object> getImageProvider() {
    if (event.photo.isNotEmpty) {
      if (Uri.tryParse(event.photo)?.hasAbsolutePath ?? false) {
        if (event.photo.startsWith('http')) {
          return NetworkImage(event.photo);
        } else {
          return AssetImage(event.photo);
        }
      }
    }
    return const AssetImage('lib/images/placeholder.png');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Column(
          children: [
            const SizedBox(height: 25),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: getImageProvider(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, bottom: 12),
              child: Center(
                child: Text(
                  event.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text("Type: ${event.eventType}", softWrap: true, textAlign: TextAlign.center),
            Text("Location: ${event.location}", softWrap: true, textAlign: TextAlign.center),
            Text("Info: ${event.info}", softWrap: true, textAlign: TextAlign.center),
            if (event.date.isNotEmpty) Text("Date: ${event.date}", softWrap: true, textAlign: TextAlign.center),
            SizedBox(height:45),
          ],
        ),
      ),
    );
  }
}
