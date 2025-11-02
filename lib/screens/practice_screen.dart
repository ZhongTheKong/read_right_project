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

  late final RecordingProvider recordingProvider;

  @override
  void initState() {
    super.initState();
    recordingProvider = RecordingProvider();
    recordingProvider.initAudio(mounted);
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider.value(
      value: recordingProvider,
      child: Scaffold(
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
                child: Consumer<RecordingProvider>(
                  builder: (context, RecordingProvider recordingProviderReference, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        
                      IconButton(
                        onPressed: () => recordingProviderReference.incrementIndex(-1), 
                        icon: Icon(
                          Icons.arrow_left
                        ),
                      ),
                        
                      Column(
                        children: [
                          Text(
                            'Word #${recordingProviderReference.index + 1}',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            recordingProviderReference.word_list[recordingProviderReference.index],
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                        
                      IconButton(
                        onPressed: () => recordingProviderReference.incrementIndex(1), 
                        icon: Icon(
                          Icons.arrow_right
                        ),
                      )
                    ],
                  ),
                ),
              ),
      
              const SizedBox(height: 20),
      
              Container(
                width: 400,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Consumer<RecordingProvider>(
                    builder: (BuildContext context, RecordingProvider recordingProviderReference, Widget? child) => LinearProgressIndicator(
                      value: recordingProviderReference.elapsedMs / RecordingProvider.kMaxRecordMs >= 0.99 
                            ? 1.0 
                            : recordingProviderReference.elapsedMs / RecordingProvider.kMaxRecordMs,
                      minHeight: 10,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
      
              Container(
                color: Colors.blue,
                child: Consumer<RecordingProvider>(
                  builder: (BuildContext context, RecordingProvider recordingProviderReference, Widget? child) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          recordingProviderReference.startRecording();
                        },
                        icon: const Icon(Icons.mic),
                        label: const Text('Start'),
                      ),
                      const SizedBox(width: 20),
                  
                      ElevatedButton.icon(
                        onPressed: () {
                          recordingProviderReference.stopRecording();
                        },
                        icon: const Icon(Icons.stop_circle_outlined),
                        label: const Text('Stop'),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
      
              const SizedBox(height: 20),
      
              Consumer<RecordingProvider>(
                builder: (BuildContext context, RecordingProvider recordingProviderReference, Widget? child) => Expanded(
                  child: recordingProviderReference.attempts.isEmpty
                  ? const Center(
                      child: Text('No attempts yet. Record your first try!')
                  )
                  : ListView.separated(
                      itemCount: recordingProviderReference.attempts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                      
                      
                        final iterAttempt = recordingProviderReference.attempts[i];
                        final exists = File(iterAttempt.filePath).existsSync();
                      
                      
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(width: 0.5),
                          ),
                          title: Text(iterAttempt.word),
                      
                          subtitle: Text(
                              'Date: ${iterAttempt.createdAt.toLocal()}\nDuration: ~${(iterAttempt.durationMs / 1000).toStringAsFixed(1)}s'),
                      
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min, 
                            children: [
                              IconButton(
                                tooltip: 'Play',
                                onPressed: (!exists || recordingProviderReference.isPlaying)
                                    ? null
                                    : () => recordingProviderReference.play(iterAttempt.filePath),
                                icon: const Icon(Icons.play_arrow),
                              ),
                              
                              IconButton(
                                tooltip: 'Stop',
                      
                                // TODO: CREATE A BETTER PLAY ATTEMPT BUTTON CALLBACK
                                onPressed: recordingProviderReference.isPlaying
                                    ? () => recordingProviderReference.player.stop().then(
                                        (_) => setState(() => recordingProviderReference.isPlaying = false))
                                    : null,
                      
                                icon: const Icon(Icons.stop),
                              ),
                            ]
                          ),
                        );
                      
                        
                      },
                  ),
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
      ),
    );
  }
}
