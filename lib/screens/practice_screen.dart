import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:read_right_project/utils/word.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  // This Future will hold the loading operation and ensure it only runs once.
  Future<void>? _loadWordsFuture;
  bool _isAudioInitialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // We initialize the future here because it has access to the provider context
    // and runs before the first build. This prevents the future from being
    // re-called on every rebuild.
    if (_loadWordsFuture == null) {
      final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
      // Trigger the loading process.
      _loadWordsFuture = sessionProvider.loadWordList('assets/seed_words.csv');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PRACTICE'),
      ),
      // Use FutureBuilder to handle the asynchronous loading of the word list.
      body: FutureBuilder<void>(
        future: _loadWordsFuture,
        builder: (context, snapshot) {
          // While the future is waiting, show a loading spinner.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          // If an error occurred during loading, display an error message.
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error: Failed to load words.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          // Once the data is loaded, build the main UI.
          // We use a Consumer to ensure the UI rebuilds with the latest provider data.
          return Consumer2<SessionProvider, RecordingProvider>(
            builder: (context, sessionProvider, recordingProvider, child) {
              if (!_isAudioInitialized) {
                recordingProvider.initAudio();
                _isAudioInitialized = true;
              }
              // After a successful load, double-check that the list is not empty.
              if (sessionProvider.word_list.isEmpty) {
                return const Center(
                  child: Text(
                    'No words found in the file.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }

              // Initialize the audio here, safely after loading.
              // recordingProvider.initAudio(mounted);

              // Safely get the current Word object from the list.
              final Word currentWord = sessionProvider.word_list[sessionProvider.index];

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // WORD DISPLAY
                    SizedBox(
                      width: 800,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Word #${sessionProvider.index + 1}\n'
                                      'Grade: ${currentWord.grade}', // Use the 'grade' property
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  currentWord.text, // Use the 'text' property
                                  style: const TextStyle(fontSize: 40),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // LINEAR PROGRESS INDICATOR
                    Container(
                      width: 400,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: recordingProvider.elapsedMs / RecordingProvider.kMaxRecordMs,
                          minHeight: 10,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        ),
                      ),
                    ),

                    // RECORDING CONTROLS
                    Container(
                      width: 450,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              recordingProvider.startRecording(
                                currentWord.text, // Pass the word text
                                sessionProvider.attempts,
                              );
                            },
                            icon: const Icon(Icons.mic),
                            label: const Text('Record'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              recordingProvider.stopRecording(
                                currentWord.text, // Pass the word text
                                sessionProvider.attempts,
                              );
                              sessionProvider.selectedIndex = sessionProvider.index;
                              setState(() {});
                            },
                            icon: const Icon(Icons.stop_circle_outlined),
                            label: const Text('Stop'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Playback logic
                              if (sessionProvider.attempts.length > sessionProvider.index) {
                                recordingProvider.play(sessionProvider.attempts[sessionProvider.index].filePath);
                              }
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Playback'),
                          ),
                        ],
                      ),
                    ),

                    // FEEDBACK CONTROLS
                    Container(
                      width: 500,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              sessionProvider.selectedIndex = sessionProvider.index;
                              Navigator.pushNamed(context, AppRoutes.feedback);
                            },
                            child: const Text('Review Feedback'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.wordList);
                            },
                            child: const Text('Go to Word List'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.progress);
                            },
                            child: const Text('View Progress'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
