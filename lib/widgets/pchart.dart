

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:torno_chat_app/createmessage.dart';

import 'package:torno_chat_app/widgets/messaget_tile.dart';

class PersonalChat extends StatefulWidget {
  final String userId;
  final String userName;

  const PersonalChat({Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getChats();
  }

  void _getChats() {
    getChats(widget.userId).listen((val) {
      setState(() {
        chats = val as Stream<QuerySnapshot>?;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        children: [
          Expanded(child: chatMessages()),
          buildMessageInputField(),
        ],
      ),
    );
  }

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        else if (snapshot.hasData) {
          final messages = snapshot.data?.docs;
          return ListView.builder(
            itemCount: messages?.length,
            itemBuilder: (context, index) {
              final message = messages?[index];
              final messageText = message?['message'];
              final senderId = message?['senderId'];
              final senderName = message?['senderName'];
              final isSentByMe =
                  senderId == FirebaseAuth.instance.currentUser!.uid;

              return MessageTile(
                message: messageText,
                sender: senderName,
                Sentbyme: isSentByMe,
              );
            },
          );
        }
        else 
        {
          return Text("No message has been set");
        }
      },
    );
  }

  Widget buildMessageInputField() {
    return Stack(
      children: <Widget>[
        Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Send a message....",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ]),
            ))
      ],
    );
  }

  void sendMessage() {
    String messageText = messageController.text.trim();
    if (messageText.isNotEmpty && FirebaseAuth.instance.currentUser != null) {
      String senderId = FirebaseAuth
          .instance.currentUser!.uid; // Null check operator used safely here
      String receiverId = widget.userId;
      String? senderName = FirebaseAuth.instance.currentUser!.displayName;
      String receiverName = widget.userName;

      createMessage(
          messageText, senderId, receiverId, senderName, receiverName);
      messageController.clear();
    } else {
      // Handle the case when FirebaseAuth.instance.currentUser is null
      // You can show an error message or perform any other appropriate action
      print('Current user is null');
    }
  }

  Stream<QuerySnapshot> getChats(String userId) {
    // Query messages where either senderId or receiverId matches the userId
    return FirebaseFirestore.instance
        .collection('messages')
        .where('senderId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('receiverId', isEqualTo: userId)
        .orderBy('time', descending: true) // Order by time in descending order
        .snapshots();
  }
}
