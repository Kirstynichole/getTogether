import 'package:flutter/material.dart';
import 'package:get_together/components/user_tile.dart';
import 'package:get_together/pages/messaging_page.dart';
import 'package:get_together/services/auth_service.dart';
import 'package:get_together/services/chat/chat_services.dart';
import 'package:google_fonts/google_fonts.dart';


class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messages",
          style: GoogleFonts.robotoMono()),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // Build individual list tile for user
  Widget _buildUserListItem(
  Map<String, dynamic> userData, BuildContext context) {
  // Display all users except current user
  if (userData['email'] != _authService.getCurrentUser()!.email) {
    return UserTile(
      text: userData["email"],
      onTap: (getFriendUsernamesInterestedInEvent) {
        _handleTileTap(context, userData['email'], userData['uid']);
      },
    );
  } else {
    return Container();
  }
}

  // Navigate to messaging page on tile tap
  void _handleTileTap(BuildContext context, String receiverEmail, String receiverID) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MessagingPage(
        receiverEmail: receiverEmail,
        receiverID: receiverID,
      ),
    ),
  );
}
}
