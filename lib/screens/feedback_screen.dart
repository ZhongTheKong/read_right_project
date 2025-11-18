import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
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

    double score = attempts[attempts.length - 1].score;

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

    RecordingProvider recordingProvider = context.read<RecordingProvider>();

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Feedback')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Container(
            // width: 500,
            // color: Colors.blue[50],
            // child: Row(
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
                      attempts[attempts.length - 1].word,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Date: ${attempts[attempts.length - 1].createdAt.toString()}',
                      style: TextStyle(fontSize: 12),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 20),

            // ),


            Text(
              "Score: ${attempts[attempts.length - 1].score.toString()}",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),


            Text(
              "Feedback: $feedback",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // sessionProvider.nextWord('Perfect!', true);
                        // Navigator.pushNamed(context, '/practice');
                      },
                      child: const Text('Play Recording'),
                    ),
                    const SizedBox(width: 20),
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
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "What was heard: ???",
                ),
                const SizedBox(height: 20),
              ],
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
      ),
    );
   }
}

