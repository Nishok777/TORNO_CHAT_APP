import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:torno_chat_app/creategroup.dart';
import 'package:torno_chat_app/helper.dart';
import 'package:torno_chat_app/widgets/gchat.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController SearchController = TextEditingController();
  QuerySnapshot? searchsnap;
  bool hasusersearch=false;
  bool load=false;
  String username="";
  bool isjoined=false;
  User? user;
  getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuseridandname();
  }
  getcurrentuseridandname() async
  {
    await Helper.getUserNameSF().then((value){
      setState(() {
        username=value!;
      });
    });
    user=FirebaseAuth.instance.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: const Text(
          "Search",
          style: TextStyle(
              fontSize: 37, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue[700],
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: SearchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Groupss...",
                            hintStyle: TextStyle(color: Colors.white)))),
                    GestureDetector(
                      onTap:(){
                        initiatesearchmethod();
                      },
                      child: Container(
                        width:40,
                        height:40,
                        decoration:BoxDecoration(
                          color:Colors.white.withOpacity(0.1),
                          borderRadius:BorderRadius.circular(40),
                        ),
                        child:const Icon(Icons.search,color:Colors.white),
                      ),
                    )
              ],
            ),
          ),
          load?Center(child:CircularProgressIndicator(color:Colors.blue[700])):grouplist(),
        ],
      ),
    );
  }
  initiatesearchmethod() async
  {
    if(SearchController.text.isNotEmpty)
    {
      setState(()
      {
        load=true;
      });
      await searchByname(SearchController.text).then((snapshot)
      {
        setState(()
        {
          searchsnap=snapshot;
          load=false;
          hasusersearch=true;
        });
        
      });
    }
  }
  grouplist(){
    return hasusersearch?ListView.builder(shrinkWrap: true,itemCount: searchsnap!.docs.length,
    itemBuilder:(context, index){
      return grouptile(
        username,searchsnap!.docs[index]['groupid'],searchsnap!.docs[index]['groupName'],searchsnap!.docs[index]['admin'],
      );
    },):Container();
  }
  joinedornot(String name,String id,String groupname,String admin) async
  {
    await isuserjoined(groupname, id, username,user!.uid).then((value){
      setState(() {
        isjoined=value;
      });
    });
  }
  Widget grouptile(
    String name,String id,String groupname,String admin
  ){
    joinedornot(name,id,groupname,admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      leading: CircleAvatar(
        radius: 30.0,
        backgroundColor: Colors.blue[700],
        child: Text(name.substring(0,1).toUpperCase(),style: const TextStyle(color: Colors.white),),
        
      ),
      title: Text(name,style: const TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text("ADMIN: ${getName(admin)}"),
      trailing: InkWell(
        onTap: ()async{
          await toggleGroupJoin(id, name, groupname, user!.uid);
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
          Future.delayed( const Duration(seconds: 2),(){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Gchat(GroupId: id, Groupname: groupname, userName: name)),
              );
          });
          }
          else{
            setState(() {
              isjoined=!isjoined;
               ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text("Left the group $groupname"),

              duration: const Duration(seconds: 3),
            ),
          );
            });
          }
        },
        child: isjoined?Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white,width: 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text("Joined",style: TextStyle(color: Colors.white),),
        ):Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.blue[700],
          ),
            padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child:const Text("Join Now",style: TextStyle(color: Colors.white),)
        ),
      ),
    );
  }
}
