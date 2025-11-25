import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:read_right_project/utils/student_user_data.dart';
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

    AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();
    RecordingProvider recordingProvider1 = context.read<RecordingProvider>();
    bool isOnline = false;

    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text("PRACTICE"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green : Colors.red,
                        shape: BoxShape.circle, // Makes the container circular
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      isOnline ? "ONLINE" : "OFFLINE",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(width: 20,),
            Row(
              children: [
                Text(
                  "Save\nAudio",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: recordingProvider1.isAudioRetentionEnabled,
                  onChanged: (value) {
                    setState(() {
                      recordingProvider1.isAudioRetentionEnabled = value;
                    }); 
                  }
                ),
              ],
            )
          ],
        )

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
              final listComplete = sessionProvider.listComplete;
              if (listComplete) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
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
                                    'List Complete!',
                                    style: const TextStyle(fontSize: 100),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      // sessionProvider.nextWord('Needs work', false);
                                      sessionProvider.nextWord(false);
                                      Navigator.pushNamed(context, '/practice');
                                    },
                                    child: const Text('Next List')
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                );
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // WORD DISPLAY
                    Expanded(
                      child: SizedBox(
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
                    ),

                    const SizedBox(height: 10),

                    // LINEAR PROGRESS INDICATOR
                    Container(
                      width: 350,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          // value: recordingProvider.progress,
                          value: recordingProvider.elapsedMs / RecordingProvider.kMaxRecordMs,
                          minHeight: 10,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        ),
                      ),
                    ),

                    // Slider(
                    //   value: recordingProvider.currentPosition.inMilliseconds.toDouble(),
                    //   max: recordingProvider.totalDuration.inMilliseconds.toDouble(),
                    //   onChanged: (value) {
                    //     recordingProvider.player.seek(Duration(milliseconds: value.toInt()));
                    //   },
                    // ),

                    // RECORDING CONTROLS
                    Container(
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
                          Flexible(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                            
                                final studentData = allUsersProvider.allUserData.lastLoggedInUser as StudentUserData;
                                final wordListName = sessionProvider.word_list_name;
                                // Ensure the key exists
                                studentData.word_list_attempts.putIfAbsent(wordListName, () => []);
                                // Now it's safe to access
                                final attempts = studentData.word_list_attempts[wordListName]!; // non-nullable
                            
                                try {
                                  await recordingProvider.startRecording(
                                    currentWord.text, // Pass the word text
                                    attempts,
                                    () { 
                                      Navigator.pushReplacementNamed(context, AppRoutes.feedback); 
                                    }
                                  );
                                  allUsersProvider.saveCurrentUserData();
                            
                                } catch (e) {
                                  showDialog(
                                    context: context, 
                                    builder: (context) => AlertDialog(
                                      title: Text("App Missing Microphone Permissions"),
                                      content: Text("Microphone is disabled for this app. To utilize recording functionality, please enable microphone permissions for this app in device settings."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }, 
                                          child: Text("Close")
                                        ),
                                      ],
                                    )
                                  );
                                }
                              },
                              icon: const Icon(Icons.mic),
                              label: const Text('Record'),
                            ),
                          ),

                          Flexible(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                            
                                final studentData = allUsersProvider.allUserData.lastLoggedInUser as StudentUserData;
                                final wordListName = sessionProvider.word_list_name;
                                // Ensure the key exists
                                studentData.word_list_attempts.putIfAbsent(wordListName, () => []);
                                // Now it's safe to access
                                final attempts = studentData.word_list_attempts[wordListName]!; // non-nullable
                            
                                // print("Before stop recording: $attempts");
                                await recordingProvider.stopRecording(
                                  currentWord.text, // Pass the word text
                                  // sessionProvider.attempts,
                                  attempts,
                                  () { 
                                    Navigator.pushReplacementNamed(context, AppRoutes.feedback); 
                                  }
                                );
                                // print("After stop recording: $attempts");
                                sessionProvider.selectedIndex = sessionProvider.index;
                                allUsersProvider.saveCurrentUserData();
                            
                                setState(() {});
                              },
                              icon: const Icon(Icons.stop_circle_outlined),
                              label: const Text('Stop'),
                            ),
                          ),

                          Flexible(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                sessionProvider.nextWord(false);
                              }, 
                              icon: Icon(Icons.play_arrow),
                              label: Text("Next (TEMP)")
                            ),
                          )

                          // const SizedBox(width: 20),
                          // ElevatedButton.icon(
                          //   onPressed: () async {
                              
                          //     final studentData = allUsersProvider.allUserData.lastLoggedInUser as StudentUserData;
                          //     final wordListName = sessionProvider.word_list_name;
                          //     // Ensure the key exists
                          //     studentData.word_list_attempts.putIfAbsent(wordListName, () => []);
                          //     // Now it's safe to access
                          //     final attempts = studentData.word_list_attempts[wordListName]!; // non-nullable
                              
                          //     // Playback logic
                          //     // if (sessionProvider.attempts.length > sessionProvider.index) {
                          //     if (attempts.isNotEmpty) {
                          //       // recordingProvider.play(sessionProvider.attempts[sessionProvider.index].filePath);
                          //       print("Attempting to play file at location: ${attempts[0].filePath}");
                          //       allUsersProvider.saveUserData(allUsersProvider.allUserData);
                          //       await recordingProvider.play(attempts[0].filePath);

                          //     }
                          //   },
                          //   icon: const Icon(Icons.play_arrow),
                          //   label: const Text('Playback'),
                          // ),

                        ],
                      ),
                    ),

                    // FEEDBACK CONTROLS
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // ElevatedButton(
                          //   onPressed: () {
                          //     sessionProvider.selectedIndex = sessionProvider.index;
                          //     Navigator.pushNamed(context, AppRoutes.feedback);
                          //   },
                          //   child: const Text('Review Feedback'),
                          // ),
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.wordList);
                              },
                              child: const Text('Go to Word List'),
                            ),
                          ),
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.progress);
                              },
                              child: const Text('View Progress'),
                            ),
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
