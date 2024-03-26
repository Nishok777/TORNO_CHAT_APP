// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:torno_chat_app/creategroup.dart';
import 'package:torno_chat_app/details/groups.dart';
import 'package:torno_chat_app/helper.dart';
import 'package:torno_chat_app/widgets/group_tile.dart';
import 'package:torno_chat_app/widgets/personalchat.dart';
import 'package:torno_chat_app/widgets/search.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Group extends StatefulWidget {
  const Group({Key? key}) : super(key: key);

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  String Name = "";
  bool isloading = false;
  String Email = "";
  String GroupName = "";
  Stream<DocumentSnapshot>? groups;
  late Group gr;

  @override
  void initState() {
    super.initState();
    getUserData();
    getSnapshot();
  }

  String getId(String res)
  {
    return res.substring(0,res.indexOf("_"));
  }

  String getName(String res)
  {
    return res.substring(res.indexOf("_")+1);
  }

  void getSnapshot() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      setState(() {
        groups = snapshot.reference.snapshots();
      });
    });
  }

  void getUserData() async {
    await Helper.getUserEmailSF().then((value) {
      setState(() {
        Email = value!;
      });
    });
    await Helper.getUserNameSF().then((value) {
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
          "Group Chats",
          style: const TextStyle(
              fontSize: 27.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Search()),
              );
            },
          ),
        ],
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
                  MaterialPageRoute(builder: (context) => const Personal()),
                );
              },
              selectedColor: Colors.blue[700],
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: const Icon(Icons.account_circle),
              title: const Text(
                "Personal chats",
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Colors.blue[700],
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30.0,
        ),
      ),
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
        const SnackBar(content: Text('An error occurred during logout')),
      );
    }
  }

  popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: ((context, setState) {
          return AlertDialog(
            title: const Text(
              "Create a group",
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isloading
                    ? Center(
                        child:
                            CircularProgressIndicator(color: Colors.blue[700]),
                      )
                    : TextField(
                        onChanged: (value) {
                          setState(() {
                            GroupName = value;
                           
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue[700] ?? Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue[700] ?? Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      )
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("CANCEL"),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (GroupName != "") {
                    setState(() {
                      isloading = true;
                    });
                    Groups gr=Groups(gName: GroupName, admin: Name);
                    gr.members.add(Name);
                    glist.add(gr);
                    createGroup(Name, FirebaseAuth.instance.currentUser!.uid,
                            GroupName)
                        .whenComplete(() {
                      setState(() {
                        isloading = false;
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Group Created Successfully."),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    });
                  }
                },
                child: const Text("CREATE"),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
              ),
            ],
          );
        }));
      },
    );
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.get('groups') != null) {
            if (snapshot.data!.get('groups').length != 0) {
              return ListView.builder(
                itemCount: snapshot.data?['groups'].length,
                itemBuilder: (context,index)
                {
                  int reverse=snapshot.data?['groups'].length-index-1;
                 return GroupTile(
                  
  userName: snapshot.data?['name'] ?? '', // Handle null case
  groupid: getId(snapshot.data?['groups'][reverse]), // Handle null case
  groupName: getName(snapshot.data?['groups'][reverse]), // Handle null case
);

                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue[800],
            ),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => popUpDialog(context),
              child: Icon(
                Icons.add,
                size: 75.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            const Text(
              "You have not joined any group. Kindly create a group by pressing the add icon.",
            ),
            const Text(
              'Or by searching the group in the search button at the top',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
