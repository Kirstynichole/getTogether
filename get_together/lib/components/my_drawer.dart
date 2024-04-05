import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_together/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

    void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column( children: [
          DrawerHeader(
            child: Center(
              child: Image.asset(
                './lib/images/LogoNoBG.png',
                width: 400,
                height: 250,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: Text("HOME"),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: Text("SETTINGS"),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                    ),
                  );
              },
            ),
          ),
        ],

        ),

          Padding(
            padding: EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: Text("LOGOUT"),
              leading: Icon(Icons.settings),
              onTap: signUserOut,
            ),
          ),

        ],),
    );
  }
}