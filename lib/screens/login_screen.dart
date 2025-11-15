import 'package:flutter/material.dart';
import 'package:read_right_project/data/login_data.dart';
import 'package:read_right_project/models/labeled_login_text_field.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/recording_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Future<String> getLastLoggedInUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastUser = prefs.getString("lastUser");
    return lastUser ?? "";
  }

  void clearLastLoggedInUsername() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("lastUser");
  }

  void setLastLoggedInUsername(String newLoggedInUser) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("lastUser", newLoggedInUser);
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController usernameTextEditingController = TextEditingController();
    TextEditingController passwordTextEditingController = TextEditingController();

    return FutureBuilder<String?>(
      future: getLastLoggedInUsername(),
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
                        clearLastLoggedInUsername();
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
              appBar: AppBar(title: const Text('Login Screen')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hello, World! This is the Login Screen.',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),



                    const Text(
                      'Select Between Student Or Teacher',
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
                        if (LoginData.isValidLoginData(username, password) == true)
                        {
                          print("successful login");
                          setLastLoggedInUsername(username);
                          /// Share data with provider
                          Provider.of<SessionProvider>(context, listen: false).saveUsername(username);
                          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.practice, (route) => false);
                          // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        }
                        else
                        {
                          print("incorrect login");
                        }
                      },
                      child: const Text('LOGIN'),
                    ),
                    const SizedBox(height: 20),
                    
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
