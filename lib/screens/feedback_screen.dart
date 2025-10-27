import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello, World! This is the Feedback Screen.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),


            const Text(
              'Score: 0000000000000000000000',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),



            const Text(
              'Feedback: aaaaaaaaaaaaaaaaaaaa',
              style: TextStyle(fontSize: 18),
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

