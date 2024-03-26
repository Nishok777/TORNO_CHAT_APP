import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:torno_chat_app/helper.dart';
import 'package:torno_chat_app/widgets/group.dart';
import 'package:torno_chat_app/widgets/home.dart';
import 'package:torno_chat_app/widgets/loginpage.dart';
import 'package:torno_chat_app/widgets/personalchat.dart';
import 'package:torno_chat_app/widgets/registerpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool is_SignedIn=false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }
  getUserLoggedInStatus() async{
    await Helper.getUserLoggedInStatus().then((value){
    if(value!=Null)
    {
        setState(() {
          is_SignedIn=value;
        });
    }}
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: is_SignedIn?'/home':'/',
      routes: {
        '/': (context) => Loginpage(),
        '/register': (context) => Registerpage(),
        '/home':(context)=>Home(),
        '/home/personal':(context)=>Personal(),
        '/home/group':(context)=>Group(),
        
      },
    );
  }
}
