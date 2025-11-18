import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:read_right_project/utils/student_user_data.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {

    SessionProvider sessionProvider = context.watch<SessionProvider>();
    AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();


    final studentData = allUsersProvider.allUserData.lastLoggedInUser as StudentUserData;
    final wordListName = sessionProvider.word_list_name;
    // Ensure the key exists
    studentData.word_list_attempts.putIfAbsent(wordListName, () => []);
    // Now it's safe to access
    final attempts = studentData.word_list_attempts[wordListName]!; // non-nullable

    /// Catch empty attempts list
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

    // if(sessionProvider.selectedIndex == null ||
    //     sessionProvider.selectedIndex < 0 ||
    //     sessionProvider.selectedIndex >= sessionProvider.attempts.length) {
    //   context.watch<SessionProvider>().selectedIndex = 0;
    // }
    // double score = sessionProvider.attempts[sessionProvider.selectedIndex].score;

    double score = attempts[0].score;
    double previousScore = -1;
    if (attempts.length > 1)
    {
      previousScore = attempts[1].score;
    }
    final highestScore = attempts.fold<double>(
      -1, // initial value, or double.negativeInfinity if you prefer
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

    RecordingProvider recordingProvider = context.watch<RecordingProvider>();
    recordingProvider.initAudio();

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Feedback')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            // color: Colors.green[50],
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  'Word',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 10),

                Text(
                  attempts[0].word,
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Date: ${attempts[0].createdAt.toString()}',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                            "Word"
                        ),
                        IconButton(onPressed: (){}, icon: Icon(Icons.volume_up))
                      ],
                    ),
                    SizedBox(width: 50,),
                    Column(
                      children: [
                        Text(
                            "Sentence"
                        ),
                        IconButton(onPressed: (){}, icon: Icon(Icons.volume_up))
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 10),

          Table(
            columnWidths: {
              0: IntrinsicColumnWidth(), // first column auto-sizes to fit text
              1: IntrinsicColumnWidth(),      // second column takes remaining space
            },
            children: [
              TableRow(children: [
                Text(
                  "Score:  ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  attempts[0].score.toString(),
                  style: TextStyle(fontSize: 18),
                ),
                // const SizedBox(height: 20),
              ]),
              TableRow(children: [
                Text(
                  "Previous Score:  ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  previousScore == -1 ? "N/A" : previousScore.toString(),
                  style: TextStyle(fontSize: 18),
                ),
                // const SizedBox(height: 20),
              ]),
              TableRow(children: [
                Text(
                  "Highest Score:  ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  highestScore == -1 ? "N/A" : highestScore.toString(),
                  style: TextStyle(fontSize: 18),
                ),
                // const SizedBox(height: 20),
              ]),
              TableRow(children: [
                Text(
                  "Feedback:  ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  feedback,
                  style: TextStyle(fontSize: 18),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 40),

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

              // Slider(
              //   value: recordingProvider.currentPosition.inMilliseconds.toDouble(),
              //   max: recordingProvider.totalDuration.inMilliseconds.toDouble(),
              //   onChanged: (value) {
              //     recordingProvider.player.seek(Duration(milliseconds: value.toInt()));
              //   },
              // )

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
          const SizedBox(height: 40),
          Text(
            "Transcript",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),

          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                if (score > 80)
                {
                  sessionProvider.nextWord(true);
                }
                Navigator.pushReplacementNamed(context, AppRoutes.practice);
              },
              child: Text(
                  score > 80 ? "Practice Next Word" : "Retry Word"
              )
          )

          // ElevatedButton(
          //   onPressed: () {
          //     sessionProvider.nextWord('Perfect!', true);
          //     Navigator.pushNamed(context, '/practice');
          //   },
          //   child: const Text('Simulate Perfect Score'),
          // ),
          // const SizedBox(height: 20),

          // ElevatedButton(
          //   onPressed: () {
          //     sessionProvider.nextWord('Needs work', true);
          //     Navigator.pushNamed(context, '/practice');
          //   },
          //   child: const Text('Simulate Failing Score'),
          // ),
          // const SizedBox(height: 20),

          // ElevatedButton(
          //   onPressed: () {
          //     // Navigate back to main screen and clear previous routes
          //     Navigator.pushNamedAndRemoveUntil(
          //         context, '/', (route) => false);
          //   },
          //   child: const Text('Back to Main Screen'),
          // ),
        ],
      ),
    );
  }
}