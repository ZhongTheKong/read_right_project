import 'package:flutter/material.dart';
import 'package:read_right_project/models/record_button.dart';
import 'package:read_right_project/utils/routes.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello, World! This is the Practice Screen.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),


            
            RecordButton(),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                print("Button pressed");
              },
              child: const Text('Practice a Word'),
            ),
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                print("Button pressed");
              },
              child: const Text('Practice a Pair of Words'),
            ),
            const SizedBox(height: 20,),



            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.feedback);
              },
              child: const Text('Feedback'),
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
