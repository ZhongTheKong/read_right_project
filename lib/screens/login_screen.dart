import 'package:flutter/material.dart';
import 'package:read_right_project/data/login_data.dart';
import 'package:read_right_project/models/labeled_login_text_field.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
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
    List<UserData> allUserData = await allUsersProvider.getLoadedAllUserData();

    try {
      UserData userWithMatchingUsername = allUserData.firstWhere((u) => u.username == username && u.isTeacher == isTeacher);
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

    // // non existent username
    // if (!loginData.containsKey(username)) {
    //   print("Username: $username does not exist");
    //   return false;
    // }
    // // password does not match
    // if (loginData[username] != password) {
    //   print("Password: $password does not match");
    //   return false;
    // }
    // // username exists and password matches
    // return true;
  }

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

    return FutureBuilder<String?>(
      future: sessionProvider.loadUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final String lastLoggedInUsername = snapshot.data ?? '';





          if (lastLoggedInUsername != '' && lastLoggedInUsername != 'Guest') {
            return Scaffold(
              appBar: AppBar(title: const Text('Login Screen')),
              body: Center(
                child: Column(
                  children: [
                    Text("Welcome back: $lastLoggedInUsername"),
                    SizedBox(height: 20.0,),
                    ElevatedButton(
                      onPressed: () {
                        sessionProvider.clearUsername();
                        // Navigator.pushNamedAndRemoveUntil(context, AppRoutes.practice, (route) => false);
                        Navigator.pushReplacementNamed(context, AppRoutes.practice);
                        /// Improve the flow of navigation
                        Provider.of<SessionProvider>(context, listen: false).saveUsername('Guest');
                        setState(() {
                          
                        });
                        // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      },
                      child: const Text('Continue to practice screen'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        sessionProvider.clearUsername();
                        /// Improve the flow of navigation
                        Provider.of<SessionProvider>(context, listen: false).saveUsername('Guest');
                        setState(() {
                          
                        });
                        // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
                        // Navigate back to main screen and clear previous routes
                        // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

                        try
                        {
                          UserData matchingUser = await getMatchingUserData(context, sessionProvider.isTeacher, username, password);
                          sessionProvider.saveUsername(username);
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

                        // if (LoginData.isValidLoginData(username, password) == true)
                        // {
                        //   print("successful login");
                        //   sessionProvider.saveUsername(username);
                        //   /// Share data with provider
                        //   // Provider.of<SessionProvider>(context, listen: false).saveUsername(username);
                        //   // Navigator.pushNamedAndRemoveUntil(context, AppRoutes.practice, (route) => false);
                        //   Navigator.pushReplacementNamed(context, AppRoutes.practice);
                        //   // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        // }
                        // else
                        // {
                        //   print("incorrect login");
                        // }
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
                    
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Navigate back to main screen and clear previous routes
                    //     Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        
                    //   },
                    //   child: const Text('Back to Main Screen'),
                    // ),

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