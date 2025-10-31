class LoginData {
  static Map<String, String> loginData = {
    'user1' : 'pass1'
  };

  static bool isValidLoginData(String username, String password) {
    // non existent username
    if (!loginData.containsKey(username)) {
      print("Username: $username does not exist");
      return false;
    }
    // password does not match
    if (loginData[username] != password) {
      print("Password: $password does not match");
      return false;
    }
    // username exists and password matches
    return true;
  }
}