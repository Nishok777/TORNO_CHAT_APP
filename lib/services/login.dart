import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;
import 'package:torno_chat_app/utilities/authexception.dart';

Future<String?> loginUser(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Check if userCredential.user is not null, indicating successful login
    if (userCredential.user != null) {
      return "true";
    } else {
      throw WrongPasswordException();
    }
  } on FirebaseAuthException catch (e) {
    // Handle other specific authentication exceptions
    devtools.log("Login failed: ${e.message}");

    // Handle different specific exceptions if needed
    if (e.code == "user-not-found") {
      throw UserNotFoundException();
    } else if (e.code == "invalid-email") {
      throw InvalidEmailException();
    } else {
      throw e; // Re-throw other FirebaseAuthExceptions
    }
  } catch (e) {
    // Catch any other exceptions
    return 'Invalid Login id or password';
  }
}
