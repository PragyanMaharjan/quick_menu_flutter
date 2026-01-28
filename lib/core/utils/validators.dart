/// Validation utility class for form inputs
class Validators {
  /// Validates email - must end with @gmail.com
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!value.contains('@')) {
      return "Email must contain @";
    }
    if (!value.endsWith('@gmail.com')) {
      return "Email must be a Gmail account (must end with @gmail.com)";
    }
    return null;
  }

  /// Validates phone number - must be exactly 10 digits
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }
    // Remove any non-digit characters
    final cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedValue.length != 10) {
      return "Phone number must be exactly 10 digits";
    }
    return null;
  }

  /// Validates password - minimum 6 characters
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  /// Validates name - not empty
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    return null;
  }
}
