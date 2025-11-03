import 'dart:io';

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
    RecordingProvider recordingProvider = context.read<RecordingProvider>();
    recordingProvider.initAudio(mounted);
  }

  @override
  Widget build(BuildContext context) {
    
    RecordingProvider recordingProvider = context.watch<RecordingProvider>();

    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'PRACTICE'
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            // WORD DISPLAY
            SizedBox(
              width: 800,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  border: Border.all(color: Colors.blue, width: 2), // outline color & width
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      
                    Column(
                      children: [
                        SizedBox(height: 18,), // size of word # font
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2), // outline color & width
                          ),
                          child: IconButton(
                            onPressed: () => recordingProvider.incrementIndex(-1), 
                            icon: Icon(
                              Icons.arrow_left
                            ),
                          ),
                        ),
                      ],
                    ),
                      
                    Column(
                      children: [
                        Text(
                          'Word #${recordingProvider.index + 1}',
                          style: TextStyle(fontSize: 30),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              recordingProvider.word_list[recordingProvider.index],
                              style: TextStyle(fontSize: 150),
                            ),
                          ],
                        ),
                      ],
                    ),
                      
                    Column(
                      children: [
                        SizedBox(height: 18,),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2), // outline color & width
                          ),
                          child: IconButton(
                            onPressed: () => recordingProvider.incrementIndex(1), 
                            icon: Icon(
                              Icons.arrow_right
                            ),
                          ),
                        ),
                      ],
                    )
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
                    value: recordingProvider.elapsedMs / RecordingProvider.kMaxRecordMs >= 0.99 
                          ? 1.0 
                          : recordingProvider.elapsedMs / RecordingProvider.kMaxRecordMs,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  ),
              ),
            ),
            
            // RECORDING CONTROLS
            Container(
              width: 450,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[300],
                border: Border.all(color: Colors.blue, width: 2), // outline color & width
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      recordingProvider.startRecording();
                    },
                    icon: const Icon(Icons.mic),
                    label: const Text('Record'),
                  ),
                  const SizedBox(width: 20),
              
                  ElevatedButton.icon(
                    onPressed: () {
                      recordingProvider.stopRecording();
                      Navigator.pushNamed(context, AppRoutes.feedback);
                    },
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: const Text('Stop'),
                  ),
                  const SizedBox(width: 20),

                  ElevatedButton.icon(
                    onPressed: () {
                      recordingProvider.play(recordingProvider.attempts[recordingProvider.index].filePath);
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Playback'),
                  ),
                ],
              ),
            ),

            // FEEDBACK CONTROLS
            Container(
              width: 400,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[300],
                border: Border.all(color: Colors.blue, width: 2), // outline color & width
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      recordingProvider.selectedIndex = recordingProvider.index;
                      Navigator.pushNamed(context, AppRoutes.feedback);
                    },
                    child: const Text('Review Feedback'),
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
      ),
    );
  }
}
