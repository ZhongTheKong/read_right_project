import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is the Progress Screen. Here, you can see how well you are doing with your practice',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 100,
              width: 200,
              child: Column(
                children: [
                  const Text('Username: '), /// Fill in once STT stores attempts for users
                  const Text('Number of Attempts: '),
                  const Text('Average Score: '),
                ],
              )
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/practice');
              },
              child: const Text('Practice'),
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
