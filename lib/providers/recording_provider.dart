import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_right_project/utils/attempt.dart';

import 'package:mocktail/mocktail.dart';
import 'package:read_right_project/utils/pronunciation_analysis.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';

class MockAudioRecorder extends Mock implements AudioRecorder {}
class MockAudioPlayer extends Mock implements AudioPlayer {}

class RecordingProvider extends ChangeNotifier {
  AudioRecorder recorder;
  AudioPlayer player;

  RecordingProvider({AudioRecorder? recorder, AudioPlayer? player})
      : recorder = recorder ?? AudioRecorder(),
        player = player ?? AudioPlayer();

  bool recorderReady = false;
  bool isRecording = false;
  bool isPlaying = false;
  bool isTranscribing = false;

  bool isAudioRetentionEnabled = true;

  static const int kMaxRecordMs = 3000;
  Timer? recordTimer;
  int elapsedMs = 0;

  static const int intervalMs = 50;

  double progress = 0;

  /// Initializes the audio recorder. Should only be called once.
  Future<void> initAudio() async {
    // If it's already ready, don't do anything.
    if (recorderReady) return;

    final hasPerm = await recorder.hasPermission();
    if (hasPerm) {
      recorderReady = true;
      notifyListeners(); // Notify UI that the recorder is ready
    }
  }

  /// Generates the next file path for a recording.
  /// Now uses the word passed to it, making it self-contained.
  Future<String> _nextPath(String word) async {
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    // Use the word passed as a parameter for a unique filename.
    return '${dir.path}/readright_${word}_$ts.wav';
  }

  Future<void> startRecording(String word, List<Attempt> attempts, VoidCallback? onRecordStop) async {
    if (!recorderReady) {
      await initAudio();
      if (!recorderReady) {
        throw Exception("Microphone permissions missing.");
      }
    }
    if (isRecording) {
      print("Currently recording");
      return;
    }
    print("Starting recording for word: $word");

    // Generate path using the current word
    final path = await _nextPath(word);

    try {
      final config = RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 48000,
        bitRate: 128000,
      );

      await recorder.start(config, path: path);
      isRecording = true;
      elapsedMs = 0; // Reset timer
      notifyListeners();

      // Set a master timeout for the recording
      recordTimer?.cancel();
      recordTimer = Timer(const Duration(milliseconds: kMaxRecordMs), () => stopRecording(word, attempts, onRecordStop));

      // Start the periodic timer to update the UI progress bar
      recordTimer = Timer.periodic(
        const Duration(milliseconds: intervalMs),
            (timer) {
          elapsedMs = timer.tick * intervalMs;
          if (elapsedMs >= kMaxRecordMs) {
            elapsedMs = kMaxRecordMs;
            progress = elapsedMs / kMaxRecordMs;
            timer.cancel(); // Stop this timer when max time is reached
          }
          notifyListeners();
        },
      );
    } catch (e) {
      print("Error starting recording: $e");
      isRecording = false;
      notifyListeners();
    }
  }

  Future<void> stopRecording(String word, List<Attempt> attempts, VoidCallback? onRecordStop) async {
    if (!isRecording) {
      print("Not recording, cannot stop.");
      return;
    }

    recordTimer?.cancel(); // Stop the timer immediately
    print("Stopping recording");

    try {
      final path = await recorder.stop();
      isRecording = false;
      elapsedMs = 0; // Reset progress bar
      notifyListeners();

      if (path == null) {
        print("Recorder stopped but no path was returned.");
        return;
      }

      Duration? dur;
      try {
        await player.setFilePath(path);
        dur = player.duration;
        await player.stop();
      } catch (e) {
        print("Error getting recording duration: $e");
      }

      // Save the attempt to the list passed from the UI
      attempts.insert(
        0,
        Attempt(
          word: word,
          score: await getAzureResult(path, word),
          filePath: path,
          durationMs: (dur ?? Duration.zero).inMilliseconds,
        ),
      );
    } catch (e) {
      print("Error stopping recording: $e");
      // Ensure state is clean even on error
      isRecording = false;
      elapsedMs = 0;
      notifyListeners();
    }
    if (onRecordStop != null)
    {
      onRecordStop();
    }
  }

  Future<void> play(String path) async {
    if (isPlaying) return;
    print("Playing recording from: $path");

    try {
      await player.setFilePath(path);
      Duration? totalDuration = player.duration;
      elapsedMs = 0;
      isPlaying = true;
      notifyListeners();

      // TODO: ADD TRUE TRACKING OF PLAYER
      Timer.periodic(
        const Duration(milliseconds: intervalMs),
        (timer) {
          elapsedMs += intervalMs; // increment elapsed time
          if (elapsedMs >= totalDuration!.inMilliseconds) {
            elapsedMs = totalDuration.inMilliseconds;
            progress = elapsedMs / totalDuration.inMilliseconds;
            timer.cancel(); // Stop the timer when max time is reached
          }
          notifyListeners();
        },
      );
      await player.play();

      // The stream subscription should be managed carefully.
      // A simple `await player.play()` completes when the audio finishes.
      // After it finishes, update the state.
      isPlaying = false;
      notifyListeners();

    } catch (e) {
      print("Error playing audio: $e");
      isPlaying = false;
      notifyListeners();
    }
  }

  void deleteAudioFile(String path) async {
    try {
      final file = File(path);

      if (!await file.exists()) {
        throw Exception("No audio file found to delete.");
      }

      await file.delete();
      print("Audio deleted at: ${file.path}");

    } catch (e) {
      print("Error deleting audio file: $e");
      throw Exception("Failed to delete user data: $e");
    }
  }

  @override
  void dispose() {
    recorder.dispose();
    player.dispose();
    recordTimer?.cancel();
    super.dispose();
  }
}
