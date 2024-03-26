import 'package:flutter/material.dart';
import 'package:torno_chat_app/widgets/pchart.dart';
// Assuming PersonalChat is the page you want to navigate to

class PersonalTile extends StatelessWidget {
  final String userName;
  final String userId;

  const PersonalTile({
    Key? key,
    required this.userName,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalChat(
              userId: userId,
              userName: userName,
              
            ),
          ),
        );
      },
      child: SingleChildScrollView(
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.blue[700],
              child: Text(
                userName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            title: Text(
              userName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Tap to start a personal chat',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
