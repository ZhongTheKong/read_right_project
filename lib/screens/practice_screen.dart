import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/utils/routes.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {

  @override
  void initState() {
    super.initState();
    final recordingProvider = context.read<RecordingProvider>();
    recordingProvider.initAudio(mounted);
  }

  // @override
  // void dispose() {
  // THIS CREATES AN ISSUE. TRYING TO LOOK THROUGH CONTEXT WHILE DISPOSING
  //   final recordingProvider = context.read<RecordingProvider>();
  //   recordingProvider.recordTimer?.cancel();
  //   recordingProvider.player.dispose();
  //   recordingProvider.recorder.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final recordingProvider = context.watch<RecordingProvider>(); // 👈 watch

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'PRACTICE'
          )
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.red,
              child: Column(
                children: [
                  const Text(
                    'Pronounce this word/phrase',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'DOOR',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),


            
            // StartRecordButton(),
            // const SizedBox(height: 20),

            Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      recordingProvider.startRecording(mounted);
                    },
                    icon: const Icon(Icons.mic),
                    label: const Text('Start'),
                  ),
                  const SizedBox(width: 20),
              
                  ElevatedButton.icon(
                    onPressed: () {
                      recordingProvider.stopRecording(mounted);
                    },
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: const Text('Stop'),
                  ),
                  const SizedBox(width: 20),
              
                  ElevatedButton.icon(
                    onPressed: () {
                      recordingProvider.play(recordingProvider.attempts[recordingProvider.index].filePath, mounted);
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play'),
                  ),
              
                  
                  
                ],
              ),
            ),

            const SizedBox(height: 20),


            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.feedback);
              },
              child: const Text('Feedback'),
            ),
            

          ],
        ),
      ),
    );
  }
}
