String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  return null;
}

// Validator for Email
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  // Simple email validation
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

// Validator for Phone
String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  }
  // Simple phone number validation (example: must be 10 digits)
  if (value.length != 10) {
    return 'Phone number must be 10 digits';
  }
  return null;
}


// Validator for Password
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  // Check for minimum length
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}
