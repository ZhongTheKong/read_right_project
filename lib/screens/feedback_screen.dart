import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/word_list_progression_data.dart';

// flutter_tts IS CURRENTLY BUGGED FOR WINDOWS. MUST BE COMMENTED OUT
import 'package:flutter_tts/flutter_tts.dart';


// -------------------------------------------------------------
// FeedbackScreen
//
// PRE: 
//   • Must have a logged-in student in AllUsersProvider
//   • SessionProvider.word_list_name must be set
//
// Displays feedback for the most recent attempt of the current word:
//   • Word, date, scores (current, previous, highest)
//   • Feedback label (e.g., "Perfect!", "Good!")
//   • Play buttons for word audio
//   • Option to proceed to next word or retry
//
// POST: Returns a fully functional feedback UI with optional TTS and audio playback
// -------------------------------------------------------------
class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // -----------------------------------------------------------------
    // Providers used:
    //   • SessionProvider: current word list and selected word
    //   • AllUsersProvider: access logged-in student data
    //   • RecordingProvider: play back recorded attempts
    //
    // POST: Providers ready for use in UI
    // -----------------------------------------------------------------
    SessionProvider sessionProvider = context.watch<SessionProvider>();
    AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();

    final studentData = allUsersProvider.allUserData.lastLoggedInUser as StudentUserData;
    final wordListName = sessionProvider.word_list_name;

    // Ensure progression data exists for the current word list
    studentData.word_list_progression_data.putIfAbsent(
      wordListName, 
      () => WordListProgressionData(
        wordListName: wordListName, 
        wordListPath: wordListName, 
        currIndex: 0, 
        attempts: []
      )
    );

    // Access attempts safely
    final attempts = studentData.word_list_progression_data[wordListName]!.attempts;

    // -------------------------------------------------------------
    // PRE: Handle case where no attempts exist
    // POST: Show message and navigation button back to main screen
    // -------------------------------------------------------------
    if (attempts.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No attempts yet. Go practice first!',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
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
    }

    // -----------------------------------------------------------------
    // PRE: Compute scores and feedback
    // POST: Variables ready for UI display
    // -----------------------------------------------------------------
    double score = attempts[0].score;
    double previousScore = -1;
    if (attempts.length > 1) {
      previousScore = attempts[1].score;
    }

    final highestScore = attempts.fold<double>(
      -1,
      (prev, attempt) => attempt.score > prev ? attempt.score : prev,
    );

    String feedback;
    if (score == 100) {
      feedback = "Perfect!";
    } else if (90 < score && score < 100) {
      feedback = "Excellent!";
    } else if (80 < score && score <= 90) {
      feedback = "Good!";
    } else if (70 < score && score <= 80) {
      feedback = "Ok";
    } else {
      feedback = "Needs work";
    }

    // Initialize audio and TTS
    RecordingProvider recordingProvider = context.watch<RecordingProvider>();
    recordingProvider.initAudio();
    
    // flutter_tts IS CURRENTLY BUGGED FOR WINDOWS. MUST BE COMMENTED OUT
    FlutterTts flutterTts = FlutterTts();

    // -----------------------------------------------------------------
    // POST: Main Scaffold with feedback content
    // -----------------------------------------------------------------
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  "FEEDBACK",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                )
              ),
            ),
          ],
        )
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          // -------------------------------------------------------------
          // Word Display & TTS
          //
          // PRE: attempts[0] exists
          // POST: Shows current word, date, and play button for TTS
          // -------------------------------------------------------------
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text('Word', style: TextStyle(fontSize: 30)),
                      const SizedBox(height: 10),
                      Text(
                        attempts[0].word,
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Date: ${attempts[0].createdAt.toString()}',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                
                      // TTS Playback Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text("Play Word"),
                              IconButton(
                                onPressed: () async {
                                  // flutter_tts IS CURRENTLY BUGGED FOR WINDOWS. MUST BE COMMENTED OUT
                                  await flutterTts.speak(attempts[0].word);
                                }, 
                                icon: Icon(Icons.volume_up)
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
            
                const SizedBox(height: 10),
            
                // -------------------------------------------------------------
                // Table of Scores & Feedback
                //
                // PRE: Scores computed above
                // POST: Displays score, previous, highest, and textual feedback
                // -------------------------------------------------------------
                Table(
                  columnWidths: {
                    0: IntrinsicColumnWidth(),
                    1: IntrinsicColumnWidth(),
                  },
                  children: [
                    TableRow(children: [
                      Text("Score:  ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(attempts[0].score.toString(), style: TextStyle(fontSize: 18)),
                    ]),
                    TableRow(children: [
                      Text("Previous Score:  ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(previousScore == -1 ? "N/A" : previousScore.toString(), style: TextStyle(fontSize: 18)),
                    ]),
                    TableRow(children: [
                      Text("Highest Score:  ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(highestScore == -1 ? "N/A" : highestScore.toString(), style: TextStyle(fontSize: 18)),
                    ]),
                    TableRow(children: [
                      Text("Feedback:  ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(feedback, style: TextStyle(fontSize: 18)),
                    ]),
                  ],
                ),
            
                const SizedBox(height: 40),
            
                // -------------------------------------------------------------
                // Audio Playback Controls
                //
                // PRE: RecordingProvider initialized
                // POST: Plays recorded attempt and shows progress
                // -------------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await recordingProvider.play(attempts[0].filePath);
                      },
                      icon: Icon(Icons.play_arrow),
                    ),
                    const SizedBox(width: 15),
            
                    Container(
                      width: 200,
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
                  ],
                ),

              ],
            ),
          ),

          

          // -------------------------------------------------------------
          // Next / Retry Button
          //
          // PRE: score available
          // POST: Advances to next word or allows retry. Deletes audio if retention disabled.
          // -------------------------------------------------------------
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (score > 80) {
                      allUsersProvider.incrementCurrIndex(sessionProvider.word_list_name);
                      // sessionProvider.nextWord(true);
                      sessionProvider.updateIndex(allUsersProvider.getWordListCurrIndex(sessionProvider.word_list_name));
                    }
                    if (!recordingProvider.isAudioRetentionEnabled) {
                      print("Removing current attempt from ${sessionProvider.word_list_name}");
                      String? lastFilePath = (allUsersProvider.allUserData.lastLoggedInUser as StudentUserData)
                          .word_list_progression_data[sessionProvider.word_list_name]?.attempts.last.filePath;
                      allUsersProvider.saveCurrentUserData();
                      if (lastFilePath != null) {
                        recordingProvider.deleteAudioFile(lastFilePath);
                      }
                    } else {
                      print("Keeping current attempt");
                    }
                    Navigator.pushReplacementNamed(context, AppRoutes.practice);
                  },
                  child: Text(
                    score > 80 ? "Practice Next Word" : "Retry Word",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  )
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

        ],
      ),
    );
  }
}
