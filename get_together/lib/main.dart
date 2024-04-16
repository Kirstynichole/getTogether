
import 'package:flutter/material.dart';
import 'package:get_together/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: GoogleFonts.robotoMono(),
          displaySmall: GoogleFonts.robotoMono(),
        ),
      ),
      home: const AuthPage(),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:get_together/pages/login_page.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(const MaterialApp(
//     title: 'Home',
//     home: MyApp()
//   ));
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   List<dynamic> _events = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchEvents().then((events) {
//       setState(() {
//         _events = events;
//       });
//     }).catchError((error) {
//       print('Error fetching events: $error');
//     });
//   }

//   Future<List<dynamic>> fetchEvents() async {
//     final response = await http.get(Uri.parse('http://localhost:5555/events'));

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception('Failed to load events');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       routes: {
//         '/LoginPage' : (context) => const LoginPage(),
//       },
//       home: Scaffold(
//         backgroundColor: const Color.fromARGB(160, 72, 2, 74),
//         appBar: AppBar(
//           backgroundColor: const Color.fromARGB(135, 87, 4, 90),
//           leading: const IconButton(
//           icon: Icon(Icons.menu),
//           tooltip: 'Navigation menu',
//           onPressed: null,
//         ),
//           title: const Text(
//             'Event List',
//             style:
//                 TextStyle(color: Colors.white, fontSize: 25),
//           ),
//           actions: const [
//           IconButton(
//             icon: Icon(Icons.search),
//             tooltip: 'Search',
//             onPressed: null,
//           ),
//         ],
//         ),

//         body: ListView.builder(
//           itemCount: _events.length,
//           itemBuilder: (BuildContext context, int index) {
//             return ListTile(
//               title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(_events[index]['name'],
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.white,
//                         )),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Type: ${_events[index]['event_type']}',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Address: ${_events[index]['location']}',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Info: ${_events[index]['info']}',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.white,
//                       ),
//                     ),
//                   if (_events[index]['date'].isNotEmpty)
//                     ...[
//                       const SizedBox(height: 4),
//                       Text(
//                         'Date: ${_events[index]['date']}',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                 ],
//               ),
//               leading: CircleAvatar(
//                 backgroundImage: NetworkImage(_events[index]
//                     ['photo']),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



