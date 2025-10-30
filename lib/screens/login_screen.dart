import 'package:flutter/material.dart';

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
            

            Row(
              children: [
                Text(
                  "Username: ",
                ),
                SizedBox(width: 10.0),
                SizedBox(
                  width: 150.0,
                  child: TextField(
                    controller: usernameTextEditingController,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black
                    ),
                    decoration: InputDecoration(
                      labelText: '',
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.face,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),





            Row(
              children: [
                Text(
                  "Password: ",
                ),
                SizedBox(width: 10.0),
                SizedBox(
                  width: 150.0,
                  child: TextField(
                    controller: passwordTextEditingController,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black
                    ),
                    decoration: InputDecoration(
                      labelText: '',
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.key,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
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
