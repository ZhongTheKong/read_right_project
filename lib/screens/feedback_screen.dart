import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {

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
                          recordingProvider.attempts.isNotEmpty 
                            ? recordingProvider.attempts[recordingProvider.index].word
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
                          recordingProvider.attempts.isNotEmpty 
                            ? '${recordingProvider.attempts[recordingProvider.index].createdAt.toLocal()}'
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
              recordingProvider.attempts.isNotEmpty 
                ? 'Score: ${recordingProvider.attempts[recordingProvider.index].score}' 
                : 'Score: ???',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),



            Text(
              recordingProvider.attempts.isNotEmpty 
                ? 'Feedback: ${recordingProvider.attempts[recordingProvider.index].score}' 
                : 'Feedback: ???',
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
}

