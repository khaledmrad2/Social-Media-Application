import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/shared/components/constants.dart';

class functions {
  ///////////////////////////////////////////////////////////////

  static String validate_Email(String value) {
    if (value.isEmpty)
      return 'Email is required!';
    else if (!value.endsWith('@gmail.com')) {
      return 'Email must end with @gmail.com';
    }
    return null;
  }

  ///////////////////////////////////////////////////////////////

  static String validate_Password(String value) {
    RegExp regex = RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

    ///  r'^
    ///     (?=.*[A-Z])        should contain at least one upper case
    ///     (?=.*[a-z])        should contain at least one lower case
    ///     (?=.*?[0-9])       should contain at least one digit
    ///     (?=.*?[!@-_/\-*])  should contain at least one Special character
    ///       .{8,}             Must be at least 8 characters in length
    ///  $

    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password Must be more than 8 characters';
    } else if (!regex.hasMatch(value)) {
      return 'Unvalid password!';
    }
    return null;
  }

  ///////////////////////////////////////////////////////////////

  static String validate_Equal_password(value1, value2) {
    if (value1 != value2) return 'Confirm Password not equal Password';
    return null;
  }

  ///////////////////////////////////////////////////////////////

  static String validate_Name(value) {
    if (value.isEmpty) {
      return 'Name is required';
    }
    String firstLetter = value.trimLeft().substring(0, 1);
    if (value.toString().length < 2)
      return 'UserName must be at least 2 character';

    return null;
  }

  ///////////////////////////////////////////////////////////////

  static String validate_Code(value) {
    if (value.isEmpty) {
      return 'Code is required';
    } else if (value.toString().length < 6 || value.toString().length > 6)
      return 'Code Must Be 6 digits ';
    return null;
  }
}

//////////////////////////////////////////////////////////////////
///this to make first char in uppercase
String convertToTitleCase(String text) {
  if (text == null) {
    return null;
  }

  if (text.length <= 1) {
    return text.toUpperCase();
  }

  final List<String> words = text.split(' ');

  // Capitalize first letter of each words
  final capitalizedWords = words.map(
    (word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    },
  );

  ///merge
  return capitalizedWords.join(' ');
}
