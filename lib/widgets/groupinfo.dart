// ignore_for_file: non_constant_identifier_names, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:torno_chat_app/creategroup.dart';

class Groupinfo extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String GroupName;
  final String admin;
  final String GroupId;
  const Groupinfo(
      {Key? key,
      required this.GroupName,
      required this.GroupId,
      required this.admin})
      : super(key: key);

  @override
  State<Groupinfo> createState() => _GroupinfoState();
}

class _GroupinfoState extends State<Groupinfo> {
  Stream? members;
  @override
  void initState() {
    // TODO: implement initState
    getMembers();
    super.initState();
  }

  getMembers() async {
    getgroupmembers(widget.GroupId).then((value) {
      setState(() {
        members = value;
      });
    });
  }

  getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.blue[700],
        title: const Text("Group Info"),
        actions: [IconButton(onPressed: () {
          showDialog(context: context, builder: (context)
          {
            return AlertDialog(
              title: const Text("Exit"),
              content: const Text("Are you sure you want to exit the group"),
              actions: [
                IconButton(onPressed: ()
                {
                  Navigator.pop(context);
                }, icon: const Icon(Icons.cancel,color: Colors.red,),),
                IconButton(onPressed: ()async {
                  toggleGroupJoin(widget.GroupId, getName(widget.admin), widget.GroupName, FirebaseAuth.instance.currentUser!.uid)
                  .whenComplete((){
                    Navigator.pushReplacementNamed(context, '/home/group');
                  });
                }, icon: const Icon(Icons.done,color: Colors.green,))
              ],
            );
          });
        }, icon: const Icon(Icons.exit_to_app))],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.blue[700]?.withOpacity(0.2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.blue[700],
                    child: Text(
                      widget.GroupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.GroupName}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Admin: ${getName(widget.admin)}")
                    ],
                  )
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),


    );
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              if (snapshot.data['members'].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data['members'].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue[700],
                            child: Text(
                              getName(snapshot.data['members'][index]
                                  .substring(0, 1)
                                  .toUpperCase()),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(getName(snapshot.data['members'][index])),
                          subtitle: Text(
                              getName(getId(snapshot.data['members'][index]))),
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: Text("No members"),
                );
              }
            } else {
              return const Center(
                child: Text("No members"),
              );
            }
          } else {
            return CircularProgressIndicator(
              color: Colors.blue[700],
            );
          }
        });
  }
}
