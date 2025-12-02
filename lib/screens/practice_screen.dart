import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/word.dart';
import 'package:read_right_project/utils/word_list_progression_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// -------------------------------------------------------------
// PracticeScreen
//
// PRE:
//   • Must have a loaded student in AllUsersProvider
//   • SessionProvider must be initialized with a word list
//   • Assets/seed_words.csv must exist for loading default word list
//
// Displays:
//   • Current word from the list with grade
//   • Record / Stop recording controls
//   • Linear progress indicator for recording
//   • Connectivity and sync status indicators
//   • Navigation buttons to Word List and Progress
//
// POST: Returns a fully interactive practice screen with recording functionality
// -------------------------------------------------------------
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  Future<void>? _loadWordsFuture;       // Tracks async word list loading
  bool _isAudioInitialized = false;     // Ensures recording initialized once
  bool isOnline = false;                // Connectivity status indicator

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // -------------------------------------------------------------
  // PRE: Widget dependencies available
  // POST: Initializes word list loading future
  // -------------------------------------------------------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadWordsFuture == null) {
      final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
      _loadWordsFuture = sessionProvider.loadWordList('assets/seed_words.csv');
    }
  }

  // -------------------------------------------------------------
  // PRE: Called on widget creation
  // POST: Starts connectivity listener for ONLINE/OFFLINE indicator
  // -------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      setState(() {
        isOnline = result.contains(ConnectivityResult.wifi);
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // -------------------------------------------------------------
  // Checks if the device is connected to WiFi
  // -------------------------------------------------------------
  Future<bool> isConnectedToWifi() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.wifi);
  }

  @override
  Widget build(BuildContext context) {
    AllUsersProvider allUsersProvider = context.watch<AllUsersProvider>();
    RecordingProvider recordingProvider = context.read<RecordingProvider>();

    // -------------------------------------------------------------
    // POST: Main Scaffold with app bar and practice UI
    // -------------------------------------------------------------
    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Connectivity / Sync indicators
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("PRACTICE"),
                Row(
                  children: [
                    // Online status
                    Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: isOnline ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isOnline ? "ONLINE" : "OFFLINE",
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    // Sync status
                    Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: allUsersProvider.isSynced ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          allUsersProvider.isSynced ? "SYNC" : "NOT SYNC",
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Save Audio toggle
            Row(
              children: [
                const Text(
                  "Save\nAudio",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: recordingProvider.isAudioRetentionEnabled,
                  onChanged: (value) {
                    setState(() {
                      recordingProvider.isAudioRetentionEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      // -------------------------------------------------------------
      // Body: FutureBuilder ensures word list loaded asynchronously
      // -------------------------------------------------------------
      body: FutureBuilder<void>(
        future: _loadWordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error: Failed to load words.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          // -------------------------------------------------------------
          // POST: Word list loaded successfully
          // -------------------------------------------------------------
          return Consumer2<SessionProvider, RecordingProvider>(
            builder: (context, sessionProvider, recordingProvider, child) {

              // Initialize audio once
              if (!_isAudioInitialized) {
                recordingProvider.initAudio();
                _isAudioInitialized = true;
              }

              if (sessionProvider.word_list.isEmpty) {
                return const Center(
                  child: Text(
                    'No words found in the file.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }

              // Current word index & object
              int currWordInWordListIndex = allUsersProvider.getWordListCurrIndex(sessionProvider.word_list_name);
              final Word currentWord = sessionProvider.word_list[currWordInWordListIndex];
              final bool listComplete = sessionProvider.listComplete;

              // -------------------------------------------------------------
              // POST: List complete screen
              // -------------------------------------------------------------
              if (listComplete) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('List\nComplete!', style: TextStyle(fontSize: 60)),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  allUsersProvider.incrementCurrIndex(sessionProvider.word_list_name);
                                  sessionProvider.nextWord(false);
                                  Navigator.pushNamed(context, '/practice');
                                },
                                child: const Text('Next List'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // -------------------------------------------------------------
              // POST: Main practice UI with current word, record/stop, progress
              // -------------------------------------------------------------
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Word number & grade display
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Word #${currWordInWordListIndex + 1}\nGrade: ${currentWord.grade}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    // Current word text
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            currentWord.text,
                            style: const TextStyle(fontSize: 60),
                          ),
                        ),
                      ),
                    ),
                    // Linear progress indicator for recording
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
                          value: recordingProvider.elapsedMs / RecordingProvider.kMaxRecordMs,
                          minHeight: 10,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        ),
                      ),
                    ),
                    // Record / Stop / Next buttons
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
                          // Record button
                          Flexible(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final studentData = allUsersProvider.allUserData.lastLoggedInUser as StudentUserData;
                                final wordListName = sessionProvider.word_list_name;
                                studentData.word_list_progression_data.putIfAbsent(
                                  wordListName,
                                  () => WordListProgressionData(
                                    wordListName: wordListName,
                                    wordListPath: wordListName,
                                    currIndex: 0,
                                    attempts: [],
                                  ),
                                );
                                final attempts = studentData.word_list_progression_data[wordListName]!.attempts;
                                try {
                                  await recordingProvider.startRecording(
                                    currentWord.text,
                                    attempts,
                                    () { Navigator.pushReplacementNamed(context, AppRoutes.feedback); },
                                  );
                                  allUsersProvider.saveCurrentUserData();
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("App Missing Microphone Permissions"),
                                      content: const Text("Microphone is disabled for this app. Please enable microphone permissions in device settings."),
                                      actions: [
                                        TextButton(
                                          onPressed: () { Navigator.pop(context); },
                                          child: const Text("Close"),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.mic),
                              label: const Text('Record'),
                            ),
                          ),
                          // Stop button
                          Flexible(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final studentData = allUsersProvider.allUserData.lastLoggedInUser as StudentUserData;
                                final wordListName = sessionProvider.word_list_name;
                                studentData.word_list_progression_data.putIfAbsent(
                                  wordListName,
                                  () => WordListProgressionData(
                                    wordListName: wordListName,
                                    wordListPath: wordListName,
                                    currIndex: 0,
                                    attempts: [],
                                  ),
                                );
                                final attempts = studentData.word_list_progression_data[wordListName]!.attempts;
                                await recordingProvider.stopRecording(
                                  currentWord.text,
                                  attempts,
                                  () { Navigator.pushReplacementNamed(context, AppRoutes.feedback); },
                                );
                                sessionProvider.selectedIndex = currWordInWordListIndex;
                                allUsersProvider.saveCurrentUserData();
                                setState(() {});
                              },
                              icon: const Icon(Icons.stop_circle_outlined),
                              label: const Text('Stop'),
                            ),
                          ),
                          // Next word button (temporary)
                          Flexible(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                allUsersProvider.incrementCurrIndex(sessionProvider.word_list_name);
                                sessionProvider.nextWord(true);
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text("Next (TEMP)"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Navigation buttons
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
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () { Navigator.pushNamed(context, AppRoutes.wordList); },
                              child: const Text('Go to Word List'),
                            ),
                          ),
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () { Navigator.pushNamed(context, AppRoutes.progress); },
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
