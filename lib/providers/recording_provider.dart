import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_right_project/utils/attempt.dart';
import 'package:record/record.dart';

class RecordingProvider extends ChangeNotifier {

  final recorder = AudioRecorder();
  final player = AudioPlayer();

  bool recorderReady = false;
  bool isRecording = false;
  bool isPlaying = false;

  final List<String> words = const [
    'the',
    'and',
    'to',
    'said',
    'little',
    'look',
    'come',
    'here',
    'where'
  ];
  int index = 0;

  final List<Attempt> attempts = [];
  static const int kMaxRecordMs = 7000;
  Timer? recordTimer;

  Future<void> initAudio(bool mounted) async {
    // Ask for permission; on macOS this triggers the system prompt if not yet granted.
    final hasPerm = await recorder.hasPermission();
    if (!hasPerm) {
      final granted = await recorder
          .hasPermission(); // record doesn't expose a request; system will prompt on start()

      if (!granted && mounted) {
        // _snack('Microphone permission is required.');
        return;
      }
    }
    // setState(() => recordingProvider.recorderReady = true);
    recorderReady = true;
    notifyListeners();
  }

  Future<String> _nextPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/readright_${words[index]}_$ts.m4a';
  }

  Future<void> startRecording(bool mounted) async {

    // final recordingProvider = context.read<RecordingProvider>(); // 👈 watch

    // IF RECORDER IS NOT READY OR RECORDER IS ALREADY RECORDING, DON'T START RECORDING
    if (!recorderReady || isRecording) return;
    final path = await _nextPath();


    try {

      // CREATE RECORIDNG CONFIGURATION
      final config = RecordConfig(
        encoder: AudioEncoder.aacLc, // -> .m4a
        sampleRate: 44100,
        bitRate: 128000,
      );

      // RECORD
      await recorder.start(config, path: path);
      // setState(() => isRecording = true);
      isRecording = true;
      notifyListeners();

      // CANCEL EXISTING TIMER
      recordTimer?.cancel();

      // START NEW TIMER
      // IF TIMER EXPIRES, STOP RECORDING
      recordTimer =
          Timer(const Duration(milliseconds: kMaxRecordMs), () => stopRecording(mounted));

    } catch (e) {
      // _snack('Failed to start recording: $e');
    }
  }

  Future<void> stopRecording(bool mounted) async {
    // IF NOT RECORDING, CAN'T STOP RECORDING SO RETURN
    if (!isRecording) return;

    // IF RECORD TIMER EXISTS, CANCEL IT
    recordTimer?.cancel();

    try {

      // STOP RECORDER
      final path = await recorder.stop();
      // setState(() => isRecording = false);
      isRecording = false;
      notifyListeners();

      // IF RECORDING FAILED, RETURN
      if (path == null) return;

      // just_audio can probe duration if we load the file
      Duration? dur;
      try {
        await player.setFilePath(path);
        dur = player.duration;
        await player.stop();
      } catch (_) {}

      // CREATE NEW ATTEMPT AND STORE
      attempts.insert(
        0,
        Attempt(
          word: words[index],
          filePath: path,
          durationMs: (dur ?? Duration.zero).inMilliseconds,
        ),
      );

      // UPDATE UI IF RECORD BUTTON IS ON SCREEN
      // if (mounted) setState(() {});
      if (mounted) notifyListeners();

      // _snack('Saved attempt for "${_words[_index]}"');
    } catch (e) {
      // _snack('Failed to stop recording: $e');
    }
  }
}