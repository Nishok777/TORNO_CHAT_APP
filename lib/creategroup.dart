// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference userCollection =
    FirebaseFirestore.instance.collection("users");

final CollectionReference groupCollection =
    FirebaseFirestore.instance.collection("groups");

Future createGroup(String UserName, String id, String GroupName) async {
  DocumentReference groupdocumentReference = await groupCollection.add({
    "groupName": GroupName,
    "groupIcon": "",
    "admin": "${id}_$UserName",
    "members": [],
    "groupId": "",
    "recentMessage": "",
    "recentMessageSender": "",
  });

  await groupdocumentReference.update({
    "members": FieldValue.arrayUnion(["${id}_$UserName "]),
    "groupid": groupdocumentReference.id,
  });

  DocumentReference userDocumentReference = userCollection.doc(id);
  return await userDocumentReference.update({
    "groups": FieldValue.arrayUnion(["${groupdocumentReference.id}_$GroupName"])
  });
}

getChats(String groupId) async {
  print("Fetching chats for groupId: $groupId");
  return groupCollection
      .doc(groupId)
      .collection("messages")
      .orderBy("time")
      .snapshots();
}

Future getGroupAdmin(String groupId) async {
  DocumentReference d = groupCollection.doc(groupId);
  DocumentSnapshot documentSnapshot = await d.get();
  return documentSnapshot['admin'];
}

getgroupmembers(groupid) async {
  return groupCollection.doc(groupid).snapshots();
}

searchByname(String group) {
  return groupCollection.where("groupName", isEqualTo: group).get();
}

Future<bool> isuserjoined(
  
    String groupname, String groupid, String username, String uid) async {
      if(groupid.isEmpty)
      {
        print("very good");
      }
  DocumentReference userDocumentReference = userCollection.doc(uid);
  DocumentSnapshot docsnap = await userDocumentReference.get();

  List<dynamic> groups = await docsnap['groups'];
  if (groups.contains("${groupid}_$groupname")) {
    return true;
  }
  return false;
}

Future<void> toggleGroupJoin(
    String groupId, String userName, String groupName, String uid) async {
  if (groupId.isNotEmpty) {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupdocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = documentSnapshot['groups'];

    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupdocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupdocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  } else {
    print('Error: Empty group ID');
    // Handle the error appropriately, such as showing an error message to the user
  }
}

sendMessage(String groupid, Map<String, dynamic> chatmessagedata) {
  groupCollection.doc(groupid).collection("messages").add(chatmessagedata);
  groupCollection.doc(groupid).update({
    "recentMessage": chatmessagedata['message'],
    "recentMessageSender": chatmessagedata['sender'],
    "recentMessageTime": chatmessagedata['time'].toString(),
  });
}
