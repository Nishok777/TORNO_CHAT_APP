class InvalidEmailException implements Exception {
  final String message = "Invalid email address";
}

class WeakPasswordException implements Exception {
  final String message = "Password is too weak";
}

class EmailAlreadyInUseException implements Exception {
  final String message = "Email is already in use";
}

class UserNotFoundException implements Exception {
  final String message = "User not found";
}

class WrongPasswordException implements Exception {
  final String message = "Incorrect password";
}

class NetworkRequestFailedException implements Exception {
  final String message = "Network request failed";
}



