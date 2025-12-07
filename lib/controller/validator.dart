enum ValidatorResult {
  valid("Valid", "The input is valid."),

  invalidEmail("Invalid Email", "The email address is not valid."),
  emailEmpty("Email Empty", "The email address cannot be empty."),

  invalidPassword("Invalid Password", "The password is not valid."),
  passwordEmpty("Password Empty", "The password cannot be empty."),
  passwordTooShort(
    "Password Too Short",
    "The password must be at least 6 characters long",
  ),
  passwordMissingAllCriteria(
    "Weak Password",
    "The password must contain at least one uppercase letter, one lowercase letter, and one number.",
  ),

  nameEmpty("Name Empty", "The name cannot be empty."),
  nameTooShort(
    "Name Too Short",
    "The name must be at least 4 characters long.",
  ),
  invalidName("Invalid Name", "The name is not valid.");

  final String title;
  final String message;

  const ValidatorResult(this.title, this.message);
}

class Validator {
  static ValidatorResult validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (email.isEmpty) {
      return ValidatorResult.emailEmpty;
    } else if (!emailRegex.hasMatch(email)) {
      return ValidatorResult.invalidEmail;
    } else {
      return ValidatorResult.valid;
    }
  }

  static ValidatorResult validatePassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$');
    if (password.isEmpty) {
      return ValidatorResult.passwordEmpty;
    } else if (password.length < 6) {
      return ValidatorResult.passwordTooShort;
    } else if (!passwordRegex.hasMatch(password)) {
      return ValidatorResult.passwordMissingAllCriteria;
    } else {
      return ValidatorResult.valid;
    }
  }

  static ValidatorResult validateName(String name) {
    if (name.isEmpty) {
      return ValidatorResult.nameEmpty;
    } else if (name.length < 4) {
      return ValidatorResult.nameTooShort;
    } else if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(name)) {
      return ValidatorResult.invalidName;
    } else {
      return ValidatorResult.valid;
    }
  }
}
