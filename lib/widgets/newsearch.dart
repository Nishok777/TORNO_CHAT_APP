// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:torno_chat_app/widgets/newtile.dart';
class Addsearch extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String admin;
  const Addsearch({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.admin,
    
  }) : super(key: key);


  @override
  State<Addsearch> createState() => _AddsearchState();
}

class _AddsearchState extends State<Addsearch> {
  bool load=false;
  TextEditingController SearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: const Text(
          "Add Someone To your group",
          style: TextStyle(
              fontSize: 37, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: userlist(),
    );
  }
  Widget userlist() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final users = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index].data() as Map<String, dynamic>;
            final userName = userData['name'] ?? '';
            final userId = userData['uid'] ?? '';
            return Newtile(userName: userName, userId: userId, groupId: widget.groupId, groupName: widget.groupName);
          },
        );
      },
    );
  }
}