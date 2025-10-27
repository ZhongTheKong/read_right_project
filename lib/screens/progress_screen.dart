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
              'Hello, World! This is the Progress Screen.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),



            Container(
              height: 100,
              width: 200,
              child: Column(
                children: [
                  const Text('Progress Chart Placeholder'),
                  const SizedBox(height: 20),
                  Icon(Icons.show_chart, size: 50, color: Theme.of(context).primaryColor)
                ],
              )
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
