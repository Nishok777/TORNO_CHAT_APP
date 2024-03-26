// ignore_for_file: non_constant_identifier_names, unused_import

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:torno_chat_app/helper.dart';
import '/utilities/authexception.dart';
import 'package:torno_chat_app/details/users.dart';
class Registerpage extends StatefulWidget {
  const Registerpage({Key? key}) : super(key: key);

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Reguser r;
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    var Size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registration Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.blue[900],
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : SingleChildScrollView(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 120.0),
                        child: Text(
                          "Torno-Chats",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0),
                        ),
                      ),
                      Container(
                        width: Size.width * 0.7,
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: Size.height * 0.01,
                      ),
                      Container(
                        width: Size.width * 0.7,
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (!RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) {
                              return 'Invalid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: Size.height * 0.01,
                      ),
                      Container(
                        width: Size.width * 0.7,
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: Size.height * 0.06,
                      ),
                      Container(
                        width: Size.width * 0.7,
                        color: Colors.blue[900],
                        child: ElevatedButton(
                          onPressed: () {
                            _register(context);
                          },
                          child: const Text("Sign Up"),
                        ),
                      ),
                      SizedBox(
                        height: Size.height * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        r = Reguser(Name: nameController.text, Email: emailController.text);
        list.add(r);
        User userCredential =
            (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
          
        
        ))
                .user!;

        if (userCredential != null) {
          await userCredential.updateDisplayName(nameController.text);
          setState(() {
            isloading = true;
          });

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.uid)
              .set({
            'uid': userCredential.uid,
            'name': nameController.text,
            'email': emailController.text,
            'groups': [],
          });

          await Helper.saveUserLoggedInStatus(true);
          await Helper.saveUserNameSF(nameController.text);
          await Helper.saveUserEmailSF(emailController.text);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Registration Successful"),
              duration: const Duration(seconds: 3),
            ),
          );

          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  "Registration failed: An unexpected error occurred"),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Error occurred')),
        );
        // if (e.code == 'email-already-in-use') {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: const Text('Email is already in use'),
        //       duration: const Duration(seconds: 3),
        //     ),
        //   );
        // } else if (e.code == 'weak-password') {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: const Text('Password is too weak'),
        //       duration: const Duration(seconds: 3),
        //     ),
        //   );
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: const Text('An error occurred'),
        //       duration: const Duration(seconds: 3),
        //     ),
        //   );
        // }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('An error occurred'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
