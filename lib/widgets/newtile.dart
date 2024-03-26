import  'package:flutter/material.dart';
import 'package:torno_chat_app/creategroup.dart';
class Newtile extends StatefulWidget {
  final String userName;
  final String userId;
  final String groupId;
  final String groupName;

  const Newtile({
    Key? key,
    required this.userName,
    required this.userId,
    required this.groupId, required this.groupName,
  
  }) : super(key: key);


  @override
  State<Newtile> createState() => _NewtileState();
}

class _NewtileState extends State<Newtile> {
  bool isjoined = false;
  late String groupname;

  @override
  void initState() {
    super.initState();
    groupname = widget.groupName; // Initialize groupname in initState
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.blue[700],
                  child: Text(
                    widget.userName.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                title: Text(
                  widget.userName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: isjoined
                    ? const Text("Joined", style: TextStyle(color: Colors.green))
                    : const Text("Join Now", style: TextStyle(color: Colors.red)),
              ),
            ),
            IconButton(
              onPressed: () async{
               await toggleGroupJoin(widget.groupId, widget.userName, widget.groupName, widget.userId);
          if(isjoined)
          {
            setState(() {
              isjoined=!isjoined;
            });
             ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Successfully joined the group'),
              duration: Duration(seconds: 3),
              
            ),
          );
         
          }
          else{
            setState(() {
              isjoined=!isjoined;
               ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text("removed from group $groupname"),

              duration: const Duration(seconds: 3),
            ),
          );
            });
          }
              },
              icon: Icon(isjoined ? Icons.remove : Icons.add),
              color: isjoined ? Colors.red : Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
