import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {

    RecordingProvider recordingProvider = context.watch<RecordingProvider>();

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


            Text(
              recordingProvider.attempts.isNotEmpty ? 'Score: ${recordingProvider.attempts[recordingProvider.index].score}' : 'Score: ???',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),



            Text(
              recordingProvider.attempts.isNotEmpty ? 'Feedback: ${recordingProvider.attempts[recordingProvider.index].score}' : 'Score: ???',
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

