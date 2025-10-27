import 'package:flutter/material.dart';

// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:record/record.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:path_provider/path_provider.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({super.key});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        print("Record Button Pressed");
      },
      // onPressed: (!_recorderReady || _isRecording)
      //     ? null
      //     : _startRecording,
      icon: const Icon(Icons.mic),
      label: const Text('Record'),
    );
  }
}