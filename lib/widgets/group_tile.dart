import 'package:flutter/material.dart';
import 'gchat.dart'; // Assuming Gchat is the page you want to navigate to

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupid;
  final String groupName;
  const GroupTile({
    Key? key,
    required this.userName,
    required this.groupid,
    required this.groupName,
  }) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Gchat(
              GroupId: widget.groupid,
              Groupname: widget.groupName,
              userName: widget.userName,
             
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
                widget.groupName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            title: Text(
              widget.groupName,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'Please join in on the conversation',
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
