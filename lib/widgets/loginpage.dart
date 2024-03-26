import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:torno_chat_app/helper.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    var Size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login Page",
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
                  key: _loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 200.0),
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
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
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
                              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
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
                              _login(context);
                            },
                            child: const Text("Sign In")),
                      ),
                      SizedBox(
                        height: Size.height * 0.02,
                      ),
                      const Text("If you are new click the below button to register"),
                      SizedBox(
                        height: Size.height * 0.02,
                      ),
                      Container(
                        width: Size.width * 0.7,
                        color: Colors.blue[900],
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text('Click here to register')),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _login(BuildContext context) async {
  if (_loginFormKey.currentState!.validate()) {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user;
      
      if (user != null) {
        // Login successful, navigate to home screen
        await Helper.saveUserLoggedInStatus(true);
        await Helper.saveUserEmailSF(emailController.text);
        await Helper.saveUserNameSF(FirebaseAuth.instance.currentUser?.displayName ?? 'Default Name');

        Navigator.pushReplacementNamed(context, '/home');
        // You can also perform other actions upon successful login
        // such as saving user login status, etc.
      } else {
        // Unexpected scenario, handle accordingly
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
    } on FirebaseAuthException catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.message ?? 'Error occurred')),
  );
      // if (e.code == 'user-not-found') {
      //   // Email doesn't exist
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Email doesn\'t exist')),
      //   );
      // } else if (e.code == 'wrong-password') {
      //   // Incorrect password
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Incorrect password')),
      //   );
      // } else {
      //   // Other FirebaseAuthException
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Invalid username or password')),
      //   );
      // }
    } catch (e) {
      // Other error occurred
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }
  }
}

}
