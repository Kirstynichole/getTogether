import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key); 

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
      final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (docSnapshot.exists) {
        final List<dynamic> friendsIds = docSnapshot.data()?['friends'] as List<dynamic>? ?? [];
        setState(() {
          _friendsList = List<String>.from(friendsIds);
        });
      }
    }
  }

  void _searchForUsers(String searchQuery) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username_lowercase', isEqualTo: searchQuery.toLowerCase())
        .get();

    final searchResults = querySnapshot.docs
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
          final List<dynamic> currentFriends = userSnapshot.data()?['friends'] as List<dynamic>? ?? [];
          if (!currentFriends.contains(friendId)) {
            transaction.update(userDocRef, {'friends': FieldValue.arrayUnion([friendId])});
          }
        }
      });
      _loadFriendsList();
    }
  }

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for users...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchForUsers(_searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchController.text.isNotEmpty ? _searchResults.length : _friendsList.length,
              itemBuilder: (context, index) {
                final username = _searchController.text.isNotEmpty ? _searchResults[index] : _friendsList[index];
                return ListTile(
                  title: Text(username),
                  trailing: IconButton(
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
