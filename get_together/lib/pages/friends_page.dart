import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}
class _FriendsPageState extends State<FriendsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _friendsList = [];
  List<String> _searchResults = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadFriendsList();
  }

  Future<void> _loadFriendsList() async {
    final user = _auth.currentUser;
    if (user != null) {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (docSnapshot.exists) {
        final List<dynamic> friendsIds =
            docSnapshot.data()?['friends'] as List<dynamic>? ?? [];
        setState(() {
          _friendsList = List<String>.from(friendsIds);
        });
      }
    }
  }

  void _searchForUsers(String searchQuery) async {
    // Lowercase the search query
    final lowercaseQuery = searchQuery.toLowerCase();

    final querySnapshot = await FirebaseFirestore.instance.collection('users').get();

    final searchResults = querySnapshot.docs
        .where((doc) =>
            doc.data()['username'].toString().toLowerCase().contains(lowercaseQuery))
        .map((doc) => doc.data()['username'].toString())
        .toList();

    setState(() {
      _searchResults = searchResults;
    });
  }

  void _addFriend(String friendId) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userDocRef);
        if (userSnapshot.exists) {
          final List<dynamic> currentFriends =
              userSnapshot.data()?['friends'] as List<dynamic>? ?? [];
          if (!currentFriends.contains(friendId)) {
            transaction.update(userDocRef, {'friends': FieldValue.arrayUnion([friendId])});
            _loadFriendsList(); // Reload friend list to reflect the update
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 242, 250, 1),
      appBar: AppBar(
        title: Text(
          "Friends",
          style: GoogleFonts.robotoMono(),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: GoogleFonts.robotoMono(),
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for users...',
                hintStyle: GoogleFonts.robotoMono(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchForUsers(_searchController.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
                // focusedBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                //   borderSide: BorderSide(
                //     color: Colors.blue,
                //     width: 2.0,
                //   ),
                // ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchController.text.isNotEmpty ? _searchResults.length : _friendsList.length,
              itemBuilder: (context, index) {
                final username =
                    _searchController.text.isNotEmpty ? _searchResults[index] : _friendsList[index];
                return ListTile(
                  title: Container(
                    decoration: BoxDecoration( 
                    color: const Color.fromRGBO(41, 23, 61, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(15),
                    child: Text(
                      username,
                      style: TextStyle( 
                        color: Colors.grey.shade200,
                        fontFamily:  GoogleFonts.robotoMono().fontFamily,
                    )),
                  ),
                  trailing: _friendsList.contains(username)
                      ? null // No icon if already a friend
                      : IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addFriend(username),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
