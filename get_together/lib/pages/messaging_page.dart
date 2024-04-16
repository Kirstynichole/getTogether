
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_together/components/chat_bubble.dart';
import 'package:get_together/components/my_textfield.dart';
import 'package:get_together/services/auth_service.dart';
import 'package:get_together/services/chat/chat_services.dart';

class MessagingPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  MessagingPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  //text controller
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //send message
  void sendMessage() async {
    //if there is something inside the text feild
    if (_messageController.text.isNotEmpty) {
      //send message
      await _chatService.sendMessage(receiverID, _messageController.text);

      //clear text controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          receiverEmail,),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    //align message to the right if the sender is the current user, otherwise left
    var alignment = 
      isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: 
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [ 
            ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
          ],
      ),
      );
  }

  //build message input
  Widget _buildUserInput() {
    return Container(
      decoration: BoxDecoration( 
      borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Row(
          children: [
            Expanded(
              child: MyTextField(
                controller: _messageController,
                hintText: "Type a message",
                obscureText: false,
              ),
            ),
        
            //send button
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(193, 109, 186, 1),
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.only(right: 25),
              child: IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward)))
          ],
        ),
      ),
    );
  }
}
