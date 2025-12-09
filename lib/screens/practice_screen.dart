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

// flutter_tts IS CURRENTLY BUGGED FOR WINDOWS. MUST BE COMMENTED OUT
import 'package:flutter_tts/flutter_tts.dart';


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
  // flutter_tts IS CURRENTLY BUGGED FOR WINDOWS. MUST BE COMMENTED OUT
  FlutterTts flutterTts = FlutterTts();


  // -------------------------------------------------------------
  // PRE: Widget dependencies available
  // POST: Initializes word list loading future
  // -------------------------------------------------------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadWordsFuture == null) {
      final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
      AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();

      // String currWordListPath = 'assets/seed_words.csv';

      _loadWordsFuture = sessionProvider.loadWordList(
        sessionProvider.currWordListPath, 
        (allUsersProvider.allUserData.lastLoggedInUser as StudentUserData).word_list_progression_data[sessionProvider.currWordListPath]?.currIndex ?? 0
      );
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
    SessionProvider sessionProvider = context.watch<SessionProvider>();

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
          // return Consumer2<SessionProvider, RecordingProvider>(
          //   builder: (context, sessionProvider, recordingProvider, child) {

          // Initialize audio once
          if (!_isAudioInitialized) {
            recordingProvider.initAudio();
            _isAudioInitialized = true;
          }

          // if (sessionProvider.word_list.isEmpty) {
          //   return const Center(
          //     child: Text(
          //       'No words found in the file.',
          //       style: TextStyle(color: Colors.white, fontSize: 18),
          //     ),
          //   );
          // }

          // Current word index & object
          int currWordInWordListIndex = allUsersProvider.getWordListCurrIndex(sessionProvider.currWordListPath);
          // final Word currentWord = sessionProvider.word_list[currWordInWordListIndex];
          // print("Word at index: $currWordInWordListIndex for word list ${sessionProvider.word_list_name} is $currentWord");

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
                    child: Row(
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          // allUsersProvider.incrementCurrIndex(sessionProvider.word_list_name);
                                          // // sessionProvider.nextWord(false);
                                          // sessionProvider.updateIndex(allUsersProvider.getWordListCurrIndex(sessionProvider.word_list_name));

                                          // sessionProvider.nextWord(false);
                                          sessionProvider.updateIndex(0);
                                          sessionProvider.currWordListIndex++;
                                          await sessionProvider.loadWordList(sessionProvider.currWordListPath, sessionProvider.currWordListIndex);
                                          // Navigator.pushNamed(context, AppRoutes.wordList);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Next List'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // -------------------------------------------------------------
          // POST: Main practice UI with current word, record/stop, progress
          // -------------------------------------------------------------
          // final String currentWord = sessionProvider.word_list[currWordInWordListIndex].$1;
          final currentWordData = sessionProvider.word_list[currWordInWordListIndex];
          final String currentWord = currentWordData.$1;

          return Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                // Word number & grade display
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          // 'Word #${currWordInWordListIndex + 1}\nGrade: ${currentWord.grade}',
                          'Word #${currWordInWordListIndex + 1}',

                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                
                // Current word text
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              // currentWord.text,
                              currentWord,
                              style: const TextStyle(fontSize: 60),
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () async {

                            final studentData = allUsersProvider.allUserData.lastLoggedInUser as StudentUserData;
                            final wordListName = sessionProvider.currWordListPath;

                            final attempts = studentData.word_list_progression_data[wordListName]!.attempts;

                            // flutter_tts IS CURRENTLY BUGGED FOR WINDOWS. MUST BE COMMENTED OUT
                            await flutterTts.speak(currentWord);
                          }, 
                          icon: Icon(
                            Icons.volume_up,
                            size: 80,
                          )
                        ),

                        ListView.builder(
                          shrinkWrap: true, // allows it to be inside another scrollable widget
                          physics: NeverScrollableScrollPhysics(), // disables inner scrolling if needed
                          itemCount: currentWordData.$2.length,
                          itemBuilder: (context, index) {
                            final word = currentWordData.$2[index];

                            return Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    // Example: speak the word
                                    // flutter_tts.speak(word);

                                    // Example: access student data if needed
                                    final studentData = allUsersProvider.allUserData.lastLoggedInUser as StudentUserData;
                                    final wordListName = sessionProvider.currWordListPath;
                                    final attempts = studentData.word_list_progression_data[wordListName]!.attempts;

                                    // flutter_tts IS CURRENTLY BUGGED FOR WINDOWS. MUST BE COMMENTED OUT
                                    await flutterTts.speak(currentWordData.$2[index]);

                                    // print('Speaking word: $word, attempts: $attempts');
                                  },
                                  icon: Icon(
                                    Icons.volume_up,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(word, style: TextStyle(fontSize: 15)),
                              ],
                            );
                          },
                        )

                        
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                
                // Linear progress indicator for recording
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                
                // Record / Stop / Next buttons
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.fromLTRB(10,0,10,0),
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Record button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final studentData = allUsersProvider.allUserData.lastLoggedInUser as StudentUserData;
                            final wordListName = sessionProvider.currWordListPath;
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
                                // currentWord.text,
                                currentWord,
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
                      SizedBox(width: 10,),
                      // Stop button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final studentData = allUsersProvider.allUserData.lastLoggedInUser as StudentUserData;
                            final wordListName = sessionProvider.currWordListPath;
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
                              // currentWord.text,
                              currentWord,
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
                      SizedBox(width: 10,),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            allUsersProvider.incrementCurrIndex(sessionProvider.currWordListPath);
                            // sessionProvider.nextWord(true);
                            sessionProvider.updateIndex(allUsersProvider.getWordListCurrIndex(sessionProvider.currWordListPath));

                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("Next (TEMP)"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                
                // Navigation buttons
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.fromLTRB(10,0,10,0),
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () { Navigator.pop(context); },
                          child: const Text('Go to Word List'),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () { Navigator.pushNamed(context, AppRoutes.progress); },
                          child: const Text('View Progress'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),

              ],
            ),
          );
        },
          // );
        // },
      ),
    );
  }
}
