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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  IconButton(
                    onPressed: () => recordingProvider.incrementIndex(-1), 
                    icon: Icon(
                      Icons.arrow_left
                    ),
                  ),

                  Column(
                    children: [
                      Text(
                        'Word #${recordingProvider.index + 1}',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        recordingProvider.words[recordingProvider.index],
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),

                  IconButton(
                    onPressed: () => recordingProvider.incrementIndex(1), 
                    icon: Icon(
                      Icons.arrow_right
                    ),
                  )
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
              
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     recordingProvider.play(recordingProvider.attempts[recordingProvider.index].filePath, mounted);
                  //   },
                  //   icon: const Icon(Icons.play_arrow),
                  //   label: const Text('Play'),
                  // ),
              
                  
                  
                ],
              ),
            ),

            const SizedBox(height: 20),

            // LinearProgressIndicator(
            //   value: recordingProvider.recordTimer.,
            //   minHeight: 10,
            //   backgroundColor: Colors.grey[300],
            //   valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
            // ),

            const SizedBox(height: 20),

            Expanded(
            child: recordingProvider.attempts.isEmpty
                ? const Center(
                    child: Text('No attempts yet. Record your first try!'))
                : ListView.separated(
                    itemCount: recordingProvider.attempts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {


                      final a = recordingProvider.attempts[i];
                      final exists = File(a.filePath).existsSync();


                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(width: 0.5),
                        ),
                        title: Text(a.word),
                        subtitle: Text(
                            'Date: ${a.createdAt.toLocal()}\nDuration: ~${(a.durationMs / 1000).toStringAsFixed(1)}s'),
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                            tooltip: 'Play',
                            onPressed: (!exists || recordingProvider.isPlaying)
                                ? null
                                : () => recordingProvider.play(a.filePath, mounted),
                            icon: const Icon(Icons.play_arrow),
                          ),
                          IconButton(
                            tooltip: 'Stop',
                            onPressed: recordingProvider.isPlaying
                                ? () => recordingProvider.player.stop().then(
                                    (_) => setState(() => recordingProvider.isPlaying = false))
                                : null,
                            icon: const Icon(Icons.stop),
                          ),
                        ]),
                      );
                    },
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
