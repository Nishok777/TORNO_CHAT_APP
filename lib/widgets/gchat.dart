
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:torno_chat_app/helper.dart';
import 'package:torno_chat_app/widgets/groupinfo.dart';
import 'package:torno_chat_app/creategroup.dart';
import 'package:torno_chat_app/widgets/messaget_tile.dart';
import 'package:torno_chat_app/widgets/newsearch.dart';

class Gchat extends StatefulWidget {
  final String GroupId;
  final String Groupname;

  final String userName;
  const Gchat({
    Key? key,
    required this.GroupId,
    required this.Groupname,
    required this.userName,
  }) : super(key: key);

  @override
  State<Gchat> createState() => _GchatState();
}

class _GchatState extends State<Gchat> {
  Stream<QuerySnapshot>? chats;
  String admin = "";
  TextEditingController messagecontroller = new TextEditingController();
   String name="";

  @override
  void initState() {
    // TODO: implement initState
    getchatAdmin();
    getName1();
    super.initState();
  }

  getchatAdmin() {
    getChats(widget.GroupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    getGroupAdmin(widget.GroupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }
  getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  getName1()
  {
    Helper.getUserNameSF().then((value){
      setState(() {
        name=value!;
      });
    });
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Groupname),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.blue[700],
        actions: [
  IconButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Groupinfo(
            GroupId: widget.GroupId,
            GroupName: widget.Groupname,
            admin: admin,
          ),
        ),
      );
    },
    icon: const Icon(Icons.info),
  ),

  if (getName(admin) == name)
    IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Addsearch(groupId: widget.GroupId, groupName: widget.Groupname, admin: admin)
          ),
        );
      },
      icon: const Icon(Icons.add),
    ),
],

      ),
      body: Stack(
        children: <Widget>[
          chatmessages(),
          Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[700],
                child: Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: messagecontroller,
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
                      sendmessage();
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ]),
              ))
        ],
      ),
    );
  }

  chatmessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          print("Snapshot has data: ${snapshot.data!.docs.length} documents");
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final message = documents[index]['message'];
              final sender = documents[index]['sender'];
              final sentByMe = widget.userName == documents[index]['sender'];

              return MessageTile(
                message: message,
                sender: sender,
                Sentbyme: sentByMe,
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}',style:TextStyle(color:Colors.black));
        } else {
          print("Snapshot has no data");
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  sendmessage() {
    if (messagecontroller.text.isNotEmpty) {
      print(messagecontroller.text);
      Map<String, dynamic> chatmessageapp = {
        "message": messagecontroller.text,
        "sender": widget.userName,
        "time:": DateTime.now().millisecondsSinceEpoch,
      };

      sendMessage(widget.GroupId, chatmessageapp);
      setState(() {
        messagecontroller.clear();
      });
    }
  }
}
