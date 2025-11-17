import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/session_provider.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {

    SessionProvider sessionProvider = context.watch<SessionProvider>();

    /// Catch empty attempts list
    if (sessionProvider.attempts.isEmpty) {
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

    if(sessionProvider.selectedIndex == null ||
        sessionProvider.selectedIndex < 0 ||
        sessionProvider.selectedIndex >= sessionProvider.attempts.length) {
      context.watch<SessionProvider>().selectedIndex = 0;
    }
    double score = sessionProvider.attempts[sessionProvider.selectedIndex].score;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.green[50],
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        'Word',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        sessionProvider.attempts.isNotEmpty
                            ? feedback
                            : '???',
                        style: TextStyle(fontSize: 18),
                      ),

                    ],
                  ),
                ),

                const SizedBox(width: 20),

                Container(
                  color: Colors.orange[50],
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        sessionProvider.attempts.isNotEmpty
                            ? '${sessionProvider.attempts[sessionProvider
                            .selectedIndex].createdAt.toLocal()}'
                            : '???',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            // ),


            Text(
              sessionProvider.attempts.isNotEmpty
                  ? 'Score: ${sessionProvider.attempts[sessionProvider
                  .selectedIndex].score}'
                  : 'Score: ???',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),


            Text(
              sessionProvider.attempts.isNotEmpty
                  ? 'Feedback: ${sessionProvider.attempts[sessionProvider
                  .selectedIndex].score}'
                  : 'Feedback: ???',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                sessionProvider.nextWord('Perfect!');
                Navigator.pushNamed(context, '/practice');
              },
              child: const Text('Simulate Perfect Score'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                sessionProvider.nextWord('Needs work');
                Navigator.pushNamed(context, '/practice');
              },
              child: const Text('Simulate Failing Score'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Navigate back to main screen and clear previous routes
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              child: const Text('Back to Main Screen'),
            ),
          ],
        ),
      ),
    );
   }
}

