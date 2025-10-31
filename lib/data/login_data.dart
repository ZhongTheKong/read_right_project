import 'package:flutter/material.dart';

class LoginData {
  Map<String, String> login_data = {
    'user1' : 'pass1'
  };

  bool isValidLoginData(String username, String password) {
    // non existent username
    if (!login_data.containsKey(username)) {
      return false;
    }
    // password does not match
    if (login_data[username] != password) {
      return false;
    }
    // username exists and password matches
    return false;
  }
}