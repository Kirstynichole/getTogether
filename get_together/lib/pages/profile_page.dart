import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_together/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> editField(String field) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(102, 0, 255, 1),
        appBar: AppBar(
          title: const Text("Profile", style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromRGBO(102, 0, 255, 1),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection("users").doc(currentUser.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting || snapshot.data?.data() == null) {
                return const Center(child: CircularProgressIndicator());
              }
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;

                return ListView(children: [
                  SizedBox(height: 50),
                  Icon(
                    Icons.person,
                    size: 72,
                    color: Colors.white,
                  ),
                  Text(currentUser.email!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text('My Details',
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextBox(
                    text: userData['username'],
                    sectionName: "Username",
                    onPressed: () => editField('username_lowercase'),
                  ),
                  TextBox(
                    text: userData['email'],
                    sectionName: "Email",
                    onPressed: () => editField('email'),
                  ),
                  TextBox(
                    text: (userData['interests'] as List<dynamic>).join(','),
                    sectionName: "Interests",
                    onPressed: () => editField('interests'),
                  ),
                  TextBox(
                    text: (userData['friends'] as List<dynamic>).join(','),
                    sectionName: "Friends",
                    onPressed: () => editField('friends')
                  ),
                ]);
              } else if (snapshot.hasError) {
                return Center(child: Text('Error ${snapshot.error}'));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}