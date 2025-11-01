import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';

class StartRecordButton extends StatefulWidget {
  const StartRecordButton({super.key});

  @override
  State<StartRecordButton> createState() => _StartRecordButtonState();
}

class _StartRecordButtonState extends State<StartRecordButton> {

  @override
  Widget build(BuildContext context) {
    final recordingProvider = context.watch<RecordingProvider>(); // 👈 watch

    return SizedBox(
      height: 200,
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              recordingProvider.startRecording(mounted);
            },
            icon: const Icon(Icons.mic),
            label: const Text('Record'),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
            onPressed: () {
              recordingProvider.stopRecording(mounted);
            },
            icon: const Icon(Icons.stop_circle_outlined),
            label: const Text('Stop'),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
            onPressed: () {
              recordingProvider.play(recordingProvider.attempts[recordingProvider.index].filePath, mounted);
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Play'),
          ),
        ],
      ),
    );
  }
}