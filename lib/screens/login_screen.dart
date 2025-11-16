import 'package:flutter/material.dart';
import 'package:read_right_project/data/login_data.dart';
import 'package:read_right_project/models/labeled_login_text_field.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/utils/all_users_data.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:read_right_project/utils/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Future<UserData> getMatchingUserData(BuildContext context, bool isTeacher, String username, String password) async {

    AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();
    AllUserData allUserData = await allUsersProvider.getAllUserData();

    try {
      UserData userWithMatchingUsername = allUserData.userDataList.firstWhere((u) => u.username == username && u.isTeacher == isTeacher);
      if (userWithMatchingUsername.password == password)
      {
        return userWithMatchingUsername;
      }
      else
      {
        throw PasswordIncorrectException();
        // return null;
      }
    } catch (e) {
      // If no user is found, return null
      throw UserNotFoundException(username);

      // return null;
    }
  }

  // Future<UserData> getMatchingUserDataOfLastUser(BuildContext context, bool isTeacher, String username) async {

  //   AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();
  //   List<UserData> allUserData = await allUsersProvider.getLoadedAllUserData();

  //   try {
  //     return allUserData.firstWhere((u) => u.username == username && u.isTeacher == isTeacher);
  //   } catch (e) {
  //     // If no user is found, return null
  //     throw UserNotFoundException(username);

  //     // return null;
  //   }
  // }

  // Future<String> getLastLoggedInUsername() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? lastUser = prefs.getString("lastUser");
  //   return lastUser ?? "";
  // }

  // void clearLastLoggedInUsername() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.remove("lastUser");
  // }

  // void setLastLoggedInUsername(String newLoggedInUser) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString("lastUser", newLoggedInUser);
  // }

  @override
  Widget build(BuildContext context) {

    TextEditingController usernameTextEditingController = TextEditingController();
    TextEditingController passwordTextEditingController = TextEditingController();

    SessionProvider sessionProvider = context.read<SessionProvider>();
    AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();

    return FutureBuilder<void>(
      future: allUsersProvider.loadUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // final String lastLoggedInUsername = allUsersProvider.allUserData!.lastLoggedInUser!.username;
          final UserData? lastLoggedInUser = allUsersProvider.allUserData!.lastLoggedInUser;





          if (lastLoggedInUser != null) {

            // sessionProvider.currUser = await getMatchingUserDataOfLastUser(context, sessionProvider.isTeacher, lastLoggedInUsername);

            return Scaffold(
              appBar: AppBar(title: const Text('Login Screen')),
              body: Center(
                child: Column(
                  children: [
                    Text("Welcome back: ${lastLoggedInUser.username}"),
                    SizedBox(height: 20.0,),

                    ElevatedButton(
                      onPressed: () {
                        // allUsersProvider.clearLastUser();
                        Navigator.pushReplacementNamed(context, AppRoutes.practice);
                        // allUsersProvider.saveLastUser(lastLoggedInUsername);
                      },
                      child: const Text('Continue to practice screen'),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        allUsersProvider.clearLastUser();
                        setState(() {});
                      },
                      child: const Text('CLEAR LAST LOGIN DATA'),
                    ),

                  ],
                ),
              )
            );
          }





          else {
            return Scaffold(
              appBar: AppBar(
                title: sessionProvider.isTeacher ? const Text('Teacher Login Screen') : const Text('Student Login Screen')
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hello, World! This is the Login Screen.',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    
                    LabelledLoginTextField(
                      textEditingController: usernameTextEditingController, 
                      fieldIcon: Icons.face, 
                      labelText: "Username"
                    ),
                    const SizedBox(height: 20),

                    LabelledLoginTextField(
                      textEditingController: passwordTextEditingController, 
                      fieldIcon: Icons.key, 
                      labelText: "Password"
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async {
                        final username = usernameTextEditingController.text;
                        final password = passwordTextEditingController.text;

                        try
                        {
                          UserData matchingUser = await getMatchingUserData(context, sessionProvider.isTeacher, username, password);
                          allUsersProvider.saveLastUser(matchingUser);
                          // sessionProvider.currUser = matchingUser;
                          Navigator.pushReplacementNamed(context, AppRoutes.practice);
                        }
                        on UserNotFoundException catch(e)
                        {
                          print("User not found: $e");
                        }
                        on PasswordIncorrectException catch(e)
                        {
                          print("Incorrect password: $e");
                        }
                      },
                      child: const Text('LOGIN'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.create_account);
                      }, 
                      child: Text("Create account"),
                    )
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }
}

class UserNotFoundException implements Exception {
  final String username;
  UserNotFoundException(this.username);

  @override
  String toString() => "UserNotFoundException: User '$username' not found";
}

class PasswordIncorrectException implements Exception {
  @override
  String toString() => "PasswordIncorrectException: Password is incorrect";
}