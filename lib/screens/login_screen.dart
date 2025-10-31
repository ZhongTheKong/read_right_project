import 'package:flutter/material.dart';
import 'package:read_right_project/data/login_data.dart';
import 'package:read_right_project/models/labeled_login_text_field.dart';
import 'package:read_right_project/models/login_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {

    TextEditingController usernameTextEditingController = TextEditingController();
    TextEditingController passwordTextEditingController = TextEditingController();

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
              onPressed: () {
                // Navigate back to main screen and clear previous routes
                // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                if (LoginData.isValidLoginData(usernameTextEditingController.text, passwordTextEditingController.text) == true)
                {
                  print("successful login");
                }
                else
                {
                  print("incorrect login");
                }
              },
              child: const Text('LOGIN'),
            ),
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                // Navigate back to main screen and clear previous routes
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: const Text('Back to Main Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
