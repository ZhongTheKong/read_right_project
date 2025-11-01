import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({super.key});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {

  @override
  void initState() {
    super.initState();
    final recordingProvider = context.read<RecordingProvider>();
    recordingProvider.initAudio(mounted);
  }

  // @override
  // void dispose() {
  //   _recordTimer?.cancel();
  //   _player.dispose();
  //   _recorder.cancel();
  //   super.dispose();
  // }


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