import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_together/components/text_box.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color.fromRGBO(193, 109, 186, 1),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.robotoMono().fontFamily,
            fontSize: 28,
          ),
        ),
        backgroundColor: const Color.fromRGBO(193, 109, 186, 1),
        elevation: 0,
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
          // var userData = snapshot.data!.data() as Map<String, dynamic>;

          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                const CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 100,
                    color:Color.fromRGBO(193, 109, 186, 1),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    currentUser.email!,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'My Details',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextBox(
                  text: userData['username'],
                  sectionName: "Username",
                  onPressed: () => editField('username_lowercase'),
                ),
                const SizedBox(height: 20),
                TextBox(
                  text: userData['email'],
                  sectionName: "Email",
                  onPressed: () => editField('email'),
                ),
                // TextBox(
                //   text: (userData['interests'] as List<dynamic>).join(', '),
                //   sectionName: "Interests",
                //   onPressed: () => editField('interests'),
                // ),
                const SizedBox(height: 20),
                TextBox(
                  text: (userData['friends'] as List<dynamic>).join(', '),
                  sectionName: "Friends",
                  onPressed: () => editField('friends'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error ${snapshot.error}'));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
