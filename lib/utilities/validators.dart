class EmailValidator {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? validate(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    } else if (!_emailRegExp.hasMatch(email)) {
      return 'Invalid email address';
    }
    return null;
  }
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}