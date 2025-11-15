import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/utils/attempt.dart';
import 'package:record/record.dart';

class RecordingProvider2 extends ChangeNotifier {

  SessionProvider? generalProvider;

  RecordingProvider2(this.generalProvider);

  final recorder = AudioRecorder();
  final player = AudioPlayer();

  bool recorderReady = false;
  bool isRecording = false;
  bool isPlaying = false;
  bool isTranscribing = false;

  int index = 0;
  int selectedIndex = 0;

  static const int kMaxRecordMs = 7000;
  Timer? recordTimer;
  int elapsedMs = 0;


  static const int intervalMs = 50;

  void updateStudent(SessionProvider newGeneralProvider) {
    generalProvider = newGeneralProvider;
  }

  Future<void> initAudio(bool mounted) async {
    final hasPerm = await recorder.hasPermission();
    if (!hasPerm) {
      final granted = await recorder.hasPermission();
      if (!granted && mounted) return;
    }
    recorderReady = true;
  }

  Future<String> _nextPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/readright_${index}_$ts.wav';
  }

  Future<void> startRecording(String word, List<Attempt> attempts) async {

    if (!recorderReady || isRecording) {
      print("Cannot start recording");
      return;
    }
    print("Starting recording");


    final path = await _nextPath();
    
    try {
      final config = RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 44100,
        bitRate: 128000,
      );

      await recorder.start(config, path: path);
      isRecording = true;
      // Start automatic transcription after recording
      // await transcribeAudio(path);
      notifyListeners();

      recordTimer?.cancel();
      recordTimer = Timer(const Duration(milliseconds: kMaxRecordMs), () => stopRecording(word, attempts));

      recordTimer = Timer.periodic(
        const Duration(milliseconds: intervalMs),
        (timer) {
          elapsedMs = timer.tick * intervalMs;
          // print("elapsed MS: ${elapsedMs}");
          if (elapsedMs >= kMaxRecordMs) {
            elapsedMs = kMaxRecordMs;
            recordTimer?.cancel();
          }
          notifyListeners();
          // timerCallback();
        },
      );
    } catch (e) {}
  }

  Future<void> stopRecording(String word, List<Attempt> attempts) async {

    if (!isRecording)
    {
      print("is recording is false");
      return;
    }
    recordTimer?.cancel();
    print("Stopping recoridng");

    try {
      final path = await recorder.stop();
      isRecording = false;
      notifyListeners();
      if (path == null) return;

      Duration? dur;
      try {
        await player.setFilePath(path);
        dur = player.duration;
        await player.stop();
      } catch (_) {}

      // Save attempt
      attempts.insert(
        0,
        Attempt(
          word: word,
          score: elapsedMs / kMaxRecordMs, // Placeholder for score
          filePath: path,
          durationMs: (dur ?? Duration.zero).inMilliseconds,
        ),
      );
    } catch (e) {}
  }

  Future<void> play(String path) async {
    if (isPlaying) return;
    print("Playing recoridng");

    try {
      await player.setFilePath(path);
      await player.play();
      isPlaying = true;
      notifyListeners();

      player.playerStateStream.listen((s) {
        if (s.processingState == ProcessingState.completed || s.playing == false) {
          isPlaying = false;
          notifyListeners();
        }
      });
    } catch (e) {}
  }

  // void incrementIndex(int increment) {
  //   if (isRecording) return;
  //   index = (index + increment) % word_list.length;
  //   notifyListeners();
  // }
}