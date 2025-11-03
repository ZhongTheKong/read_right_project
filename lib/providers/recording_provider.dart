import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_right_project/utils/attempt.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class RecordingProvider extends ChangeNotifier {
  final recorder = AudioRecorder();
  final player = AudioPlayer();
  late stt.SpeechToText _speech; // STT instance

  bool recorderReady = false;
  bool isRecording = false;
  bool isPlaying = false;
  bool isTranscribing = false;

  final List<String> word_list = const [
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
  int elapsedMs = 0;

  static const int intervalMs = 50;

  Future<void> initAudio(bool mounted) async {
    final hasPerm = await recorder.hasPermission();
    if (!hasPerm) {
      final granted = await recorder.hasPermission();
      if (!granted && mounted) return;
    }
    recorderReady = true;

    _speech = stt.SpeechToText();

    notifyListeners();
  }

  @override
  void dispose() {
    recordTimer?.cancel();
    player.dispose();
    recorder.cancel();
    super.dispose();
  }

  Future<String> _nextPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/readright_${word_list[index]}_$ts.wav';
  }

  Future<void> startRecording() async {
    if (!recorderReady || isRecording) return;
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
      recordTimer = Timer(const Duration(milliseconds: kMaxRecordMs), () => stopRecording());

      recordTimer = Timer.periodic(
        const Duration(milliseconds: intervalMs),
        (timer) {
          elapsedMs = timer.tick * intervalMs;
          if (elapsedMs >= kMaxRecordMs) {
            elapsedMs = kMaxRecordMs;
            recordTimer?.cancel();
          }
          notifyListeners();
        },
      );
    } catch (e) {}
  }

  Future<void> stopRecording() async {
    if (!isRecording) return;
    recordTimer?.cancel();

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
          word: word_list[index],
          filePath: path,
          durationMs: (dur ?? Duration.zero).inMilliseconds,
        ),
      );
      notifyListeners();


    } catch (e) {}
  }

  Future<void> play(String path) async {
    if (isPlaying) return;
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

  void incrementIndex(int increment) {
    if (isRecording) return;
    index = (index + increment) % word_list.length;
    notifyListeners();
  }

  /// Transcribes the recorded audio using speech_to_text (live transcription)
  Future<void> transcribeAudio(String path) async {
    if (isTranscribing) return;
    isTranscribing = true;
    notifyListeners();

    bool available = await _speech.initialize(
      onStatus: (status) => print('STT Status: $status'),
      onError: (error) => print('STT Error: $error'),
    );

    if (available) {
      // Start listening from the microphone instead of file
      // speech_to_text doesn't directly process audio files, so usually you replay the audio to the mic.
      // For offline file transcription, consider packages like vosk_flutter or a cloud API.
      await _speech.listen(
        onResult: (result) {
          print('Transcription: ${result.recognizedWords}');
        },
        listenFor: Duration(seconds: 10),
      );

      // Stop listening after timeout
      await Future.delayed(Duration(seconds: 10));
      _speech.stop();
    }

    isTranscribing = false;
    notifyListeners();
  }
}
