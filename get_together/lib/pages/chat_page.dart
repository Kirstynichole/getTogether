import 'package:flutter/material.dart';
import 'package:get_together/services/chat/chat_services.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final ChatService _chatService = ChatService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
      ),

    );
  }
}