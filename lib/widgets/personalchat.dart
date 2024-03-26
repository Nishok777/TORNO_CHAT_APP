// ignore_for_file: non_constant_identifier_names, unnecessary_const, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:torno_chat_app/widgets/group.dart';
import 'package:torno_chat_app/helper.dart';
import 'package:torno_chat_app/widgets/personaltile.dart';

class Personal extends StatefulWidget {
  const Personal({Key? key}) : super(key: key);

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  String Name = "";

  @override
  void initState() {
    super.initState();
    Helper.getUserNameSF().then((value) {
      setState(() {
        Name = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Chats",
          style: TextStyle(
              fontSize: 27.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          children: [
            Icon(
              Icons.account_circle,
              size: 150.0,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Text(
              Name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4.0,
            ),
            const Divider(
              height: 4.0,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Group()),
                );
              },
              selectedColor: Colors.blue[700],
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: const Icon(Icons.account_circle),
              title: const Text(
                "Group chats",
                style: TextStyle(color: Colors.red),
              ),
            ),
            ListTile(
              onTap: () {},
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: const Icon(Icons.group),
              title: const Text(
                "PROFILE",
                style: TextStyle(color: Colors.red),
              ),
            ),
            ListTile(
              onTap: () {
                _logout(context);
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "LOGOUT",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
      body: userlist(),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      await Helper.saveUserLoggedInStatus(false);
      await Helper.saveUserEmailSF("");
      await Helper.saveUserNameSF("");
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: const Text('An error occurred during logout')),
      );
    }
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
            return PersonalTile(userName: userName, userId: userId);
          },
        );
      },
    );
  }
}
