import 'package:flutter/material.dart';
import 'package:read_right_project/models/labeled_login_text_field.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/utils/all_users_data.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:read_right_project/utils/user_data.dart';
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
    AllUserData allUserData = allUsersProvider.allUserData;

      UserData userWithMatchingUsername;

    try {
      if (isTeacher)
      {
        userWithMatchingUsername = allUserData.teacherUserDataList.firstWhere((u) => u.username == username);
      }
      else
      {
        print("Searching for $username");

        userWithMatchingUsername = allUserData.studentUserDataList.firstWhere((u) => u.username == username);
      }
    } catch (e) {
      // If no user is found, return null
      throw UserNotFoundException(username);

    }
    if (userWithMatchingUsername.password == password)
    {
      return userWithMatchingUsername;
    }
    else
    {
      throw PasswordIncorrectException();
    }
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController usernameTextEditingController = TextEditingController();
    TextEditingController passwordTextEditingController = TextEditingController();

    SessionProvider sessionProvider = context.read<SessionProvider>();
    AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sessionProvider.isTeacher ? Colors.blue : Colors.red,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text(sessionProvider.isTeacher ? 'Teacher Login Screen' : 'Student Login Screen')
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.role);
              },
              child: Text("Change Roles"),
            )
          ],
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final username = usernameTextEditingController.text;
                          final password = passwordTextEditingController.text;
                      
                          try
                          {
                            UserData matchingUser = await getMatchingUserData(context, sessionProvider.isTeacher, username, password);
                            allUsersProvider.saveLastUser(matchingUser);
                            if (sessionProvider.isTeacher)
                            {
                              Navigator.pushReplacementNamed(context, AppRoutes.teacherDashboard);
                            }
                            else
                            {
                              Navigator.pushReplacementNamed(context, AppRoutes.wordList);
                            }
                          }
                          on UserNotFoundException catch(e)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Username not recognized')),
                            );
                            print("User not found: $e");
                          }
                          on PasswordIncorrectException catch(e)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Incorrect password')),
                            );
                            print("Incorrect password: $e");
                          }
                        },
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.create_account);
                        },
                        child: Text(
                          "CREATE ACCOUNT",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
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