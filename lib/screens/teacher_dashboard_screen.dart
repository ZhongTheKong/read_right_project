import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SessionProvider()..initAudio(true),
      child: Consumer<SessionProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(title: const Text('Teacher Screen')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Recording status
                  Text(
                    provider.isRecording
                        ? 'Recording...'
                        : 'Press the button to start recording',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    provider.isTranscribing
                        ? 'Transcribing...'
                        : 'Transcribed text will appear here',
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 20),

                  // Start/Stop recording button
                  ElevatedButton.icon(
                    icon: Icon(provider.isRecording ? Icons.stop : Icons.mic),
                    label: Text(provider.isRecording ? 'Stop Recording' : 'Start Recording'),
                    onPressed: () {
                      provider.transcribeAudio('');
                      // if (provider.isRecording) {
                      //   provider.stopRecording();
                      // } else {
                      //   provider.startRecording();
                      // }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Show all past attempts
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.attempts.length,
                      itemBuilder: (context, index) {
                        final attempt = provider.attempts[index];
                        return ListTile(
                          title: Text('Word: ${attempt.word}'),
                          subtitle: Text('File: ${attempt.filePath}\nDuration: ${attempt.durationMs} ms'),
                          trailing: IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () => provider.play(attempt.filePath),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Back button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                    child: const Text('Back to Main Screen'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
