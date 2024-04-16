import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_together/pages/chat_page.dart';
import 'package:get_together/pages/friends_page.dart';
import 'package:get_together/pages/interests_page.dart';
import 'package:get_together/pages/profile_page.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void _handleFriendTap(String friendEmail) {
    if (kDebugMode) {
      print('Tapped on friend with email: $friendEmail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Image.asset(
                    './lib/images/skylineNoBG.png',
                    width: 600,
                    height: 400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("HOME", style: GoogleFonts.robotoMono()),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("INTERESTS", style: GoogleFonts.robotoMono()),
                  leading: const Icon(Icons.favorite),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InterestsPage(
                          onFriendTap: _handleFriendTap,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("FRIENDS", style: GoogleFonts.robotoMono()),
                  leading: const Icon(Icons.people),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FriendsPage(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("MESSAGES", style: GoogleFonts.robotoMono()),
                  leading: const Icon(Icons.chat_rounded),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("PROFILE", style: GoogleFonts.robotoMono()),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: Text("LOGOUT", style: GoogleFonts.robotoMono()),
              leading: const Icon(Icons.settings),
              onTap: signUserOut,
            ),
          ),
        ],
      ),
    );
  }
}
