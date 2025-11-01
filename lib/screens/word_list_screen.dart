import 'package:flutter/material.dart';

class WordListScreen extends StatelessWidget {
  const WordListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word list Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello, World! This is the Word list Screen.',
              style: TextStyle(fontSize: 18),
            ),
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
            const SizedBox(height: 20),


            const Text(
              'Words on this screen will be used on practice screen.',
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
