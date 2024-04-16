
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_together/models/event.dart';
import 'package:google_fonts/google_fonts.dart'; 

class InterestsPage extends StatefulWidget {
  final Function(String)? onFriendTap;

  const InterestsPage({super.key, this.onFriendTap});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // final List<Map> _interestsList = [];
  final List<Map> _friendsInterests = [];

  Future<List<Event>> fetchInterests() async {
    final user = _auth.currentUser;
    List<Event> eventsList = [];
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (docSnapshot.exists) {
        final List<dynamic> interests =
            docSnapshot.data()?['interests'] as List<dynamic>? ?? [];
        eventsList = interests
            .map((e) => Event.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      final friendsIds = await _loadFriendsList();
      await _loadFriendsInterests(friendsIds);
    }
    return eventsList;
  }

  Future<List<String>> _loadFriendsList() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (docSnapshot.exists) {
          final List<dynamic> friendsIds =
              docSnapshot.data()?['friends'] as List<dynamic>? ?? [];
          return List<String>.from(friendsIds);
        } else {
          return [];
        }
      }
    } catch (error) {
      return [];
    }
    return [];
  }

  Future<void> _loadFriendsInterests(List<String> friendUsernames) async {
    _friendsInterests.clear();

    for (var friendUsername in friendUsernames) {
      final friendDocSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: friendUsername)
          .get();
      if (friendDocSnapshot.docs.isNotEmpty) {
        final List<dynamic> friendInterests =
            friendDocSnapshot.docs[0].data()['interests'] as List<dynamic>? ??
                [];
        for (var interest in friendInterests) {
          interest['friendUsername'] = friendUsername;
          _friendsInterests.add(interest);
        }
      }
    }
  }

  bool isFriendInterestedInEvent(Event event) {
    bool isInterested = _friendsInterests.any((interest) {
      return interest['name'] == event.name;
    });
    return isInterested;
  }

  List<String> getFriendUsernamesInterestedInEvent(Event event) {
    List<String> friendUsernames = [];
    for (var interest in _friendsInterests) {
      if (interest['name'] == event.name) {
        friendUsernames.add(interest['friendUsername']);
      }
    }
    return friendUsernames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Interests",
          style: GoogleFonts.robotoMono(),
          ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Event>>(
          future: fetchInterests(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              List<Event> events = snapshot.data!;
              if (events.isEmpty) {
                return const Center(child: Text("No interests found"));
              }
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  Event event = events[index];
                  bool isFriendInterest = isFriendInterestedInEvent(event);
                  List<String> interestedFriends =
                      getFriendUsernamesInterestedInEvent(event);
        
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration( 
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar( 
                              radius: 25,
                              backgroundImage: event.photo.startsWith("http")
                              ? NetworkImage(event.photo)
                              : AssetImage(event.photo) as ImageProvider<Object>,
                            ),
                            title: Text(
                              event.name,
                              style: TextStyle(fontFamily: GoogleFonts.robotoMono().fontFamily),
                              ),
                            subtitle: Text(event.location),
                            trailing: isFriendInterest ? const Icon(Icons.group) : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      if (isFriendInterest)
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(193, 109, 186, 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                            child: ListTile(
                              title: Text('Friends Interested: ${interestedFriends.join(", ")}'),
                              // style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                      const SizedBox(height: 10,),
                      const Divider(),
                      // if (isFriendInterest && widget.onFriendTap != null)
                      //   ...interestedFriends.map((friendEmail) => UserTile(
                      //         text: friendEmail,
                      //         onTap: (getFriendUsernamesInterestedInEvent) {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => MessagingPage(
                      //                 receiverEmail: friendEmail, receiverID: friendEmail,
                      //               ),
                      //             ),
                      //           );
                      //         },
                      //       ))
                      //       ,
                    ],
                  );
                },
              );
            } else {
              return const Center(child: Text("No interests found"));
            }
          },
        ),
      ),
    );
  }
}
