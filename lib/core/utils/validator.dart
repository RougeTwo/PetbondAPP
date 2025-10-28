import 'helper.dart';

class Validator {
  static bool isName(String text) {
    return text
        .contains(new RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"));
  }

  static bool validateString(String text) {
    return RegExp(
            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
        .hasMatch(text);
  }

  static bool isValueMatch(String value1, String value2) {
    return value1 == value2;
  }

  static String? validateStringMatch(String? value1, String? value2) {
    if (value1 == value2) {
      return "";
    } else {
      return 'Your password doesn\'t match';
    }
  }

  static String? validateConfirmPassword(String? text, String? text1) {
    String? message;
    if (text == text1) {
      return null;
    } else {
      message = 'Your password doesn\'t match';
    }
    return message;
  }

  static bool validateResetCode(String code) {
    return code.toString().length == 5;
  }

  static bool isEmail(String text) {
    bool isEmail = true;
    isEmail = Helper.emailRegExp(text);
    if (isEmail) {
      isEmail = text.isNotEmpty;
    }

    return isEmail;
  }

  static String? validateEmail(String? text) {
    String? message;
    if (text!.isEmpty) {
      message = 'Please enter email';
    }
    if (!Helper.emailRegExp(text)) {
      message = 'Please enter valid email';
    }

    return message;
  }

  static String? validatePassword(String? text,
      {validateNumberCharacters = true, validateSpecial = false}) {
    String? message;
    if (text!.isEmpty) {
      message = 'Please enter password';
    } else if (validateNumberCharacters && text.length < 5) {
      message = 'Password must be greater than 8 characters';
    } else if (validateSpecial && !validateString(text)) {
      message = 'Use at least one letter, number & special  character';
    }

    return message;
  }

  static String? validateOldPassword(String? text,
      {validateNumberCharacters = true, validateSpecial = false}) {
    String? message;
    if (text!.isEmpty) {
      message = 'Please enter old password';
    } else if (validateNumberCharacters && text.length < 8) {
      message = 'Password must be greater than 8 characters';
    } else if (validateSpecial && !validateString(text)) {
      message = 'Use at least one letter, number & special  character';
    }

    return message;
  }

  static String? validateNewPassword(String? text,
      {validateNumberCharacters = true, validateSpecial = false}) {
    String? message;
    if (text!.isEmpty) {
      message = 'Please enter new password';
    } else if (validateNumberCharacters && text.length < 8) {
      message = 'Password must be greater than 8 characters';
    } else if (validateSpecial && !validateString(text)) {
      message = 'Use at least one letter, number & special  character';
    }

    return message;
  }

  static String? validateEmptyFiled(String? text) {
    String? message;
    if (text!.isEmpty || text.length < 3) {
      message = 'This field is required';
    }

    return message;
  }

  static String? validateFirstName(String? text) {
    String? message;
    if (text!.isEmpty || text.length < 3) {
      message = 'Please enter first name';
    }

    return message;
  }

  static String? validateChipName(String? text) {
    String? message;
    if (text!.isEmpty || text.length != 15) {
      message = 'Please enter 15 digits chip number';
    }

    return message;
  }

  static String? validateLastName(String? text) {
    String? message;
    if (text!.isEmpty || text.length < 3) {
      message = 'Please enter last name';
    }

    return message;
  }

  static String? validateAddress(String? text) {
    String? message;
    if (text!.isEmpty || text.length < 3) {
      message = 'Please enter address';
    }

    return message;
  }

  static String? validatePostCode(String? text) {
    String? message;
    if (text!.isEmpty || text.length < 3) {
      message = 'Please enter postal code';
    }

    return message;
  }

  static String? validateCharityName(String? text) {
    String? message;
    if (text!.isEmpty || text.length < 3) {
      message = 'Please enter charity name';
    }

    return message;
  }

  static String? validateCharityNo(String? text) {
    String? message;
    if (text!.isEmpty || text.length < 3) {
      message = 'Please enter charity no';
    }

    return message;
  }

  static String? validatePhoneNo(String? text) {
    String? message;
    if (text!.length <= 6) {
      message = 'Please enter valid phone number';
    }

    return message;
  }

  static String? validateCharityNumber(String? text) {
    String? message;
    if (text!.isEmpty || text.length < 3) {
      message = 'Please enter charity number';
    }

    return message;
  }

  static String? validateRCVSNumber(String? text) {
    String? message;
    if (text!.isEmpty || text.length < 3) {
      message = 'Please enter valid rcvs number';
    }

    return message;
  }

  static String? validatePracticeName(String? text) {
    String? message;
    if (text!.isEmpty || text.length < 3) {
      message = 'Please enter valid practice name';
    }

    return message;
  }
}
