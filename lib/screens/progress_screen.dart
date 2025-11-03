import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recording_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<RecordingProvider>(
      builder: (context, recordingProvider, child) {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the user's data from the provider
                        Text(
                            'Username: ${recordingProvider.currentUser}',
                            style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                            'Number of Attempts: ${recordingProvider.attempts.length}',
                            style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                            'Average Score: ${recordingProvider.averageScore.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18),
                        ),
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
      },
    );
  }
}