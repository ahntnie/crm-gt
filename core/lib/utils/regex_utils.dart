part of '../core.dart';

class RegexUtils {
  static bool isUsernameValid(String userName) {
    RegExp regExp = RegExp(r'^[a-zA-Z0-9]{3,}$');
    return regExp.hasMatch(userName);
  }

  static bool isPasswordValid(String pw) {
    RegExp regExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^\w\s]).{8,}$');
    return regExp.hasMatch(pw);
  }

  static bool isEmailValid(String email) {
    RegExp regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regExp.hasMatch(email);
  }

  static bool isPhoneNumberValid(String phoneNo) {
    RegExp regExp = RegExp(r'(^(?:[+0]9)?0[0-9]{9}$)');
    return regExp.hasMatch(phoneNo);
  }
}
