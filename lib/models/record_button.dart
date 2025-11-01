import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({super.key});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {

  final _recorder = AudioRecorder();
  final _player = AudioPlayer();

  bool _recorderReady = false;
  bool _isRecording = false;
  bool _isPlaying = false;

  final List<String> _words = const [
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
  int _index = 0;

  final List<Attempt> _attempts = [];
  static const int kMaxRecordMs = 7000;
  Timer? _recordTimer;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    // Ask for permission; on macOS this triggers the system prompt if not yet granted.
    final hasPerm = await _recorder.hasPermission();
    if (!hasPerm) {
      final granted = await _recorder
          .hasPermission(); // record doesn't expose a request; system will prompt on start()
      if (!granted && mounted) {
        // _snack('Microphone permission is required.');
        return;
      }
    }
    setState(() => _recorderReady = true);
  }

  Future<void> _startRecording() async {

    // IF RECORDER IS NOT READY OR RECORDER IS ALREADY RECORDING, DON'T START RECORDING
    if (!_recorderReady || _isRecording) return;
    final path = await _nextPath();


    try {

      // CREATE RECORIDNG CONFIGURATION
      final config = RecordConfig(
        encoder: AudioEncoder.aacLc, // -> .m4a
        sampleRate: 44100,
        bitRate: 128000,
      );

      // RECORD
      await _recorder.start(config, path: path);
      setState(() => _isRecording = true);

      // CANCEL EXISTING TIMER
      _recordTimer?.cancel();

      // START NEW TIMER
      // IF TIMER EXPIRES, STOP RECORDING
      _recordTimer =
          Timer(const Duration(milliseconds: kMaxRecordMs), _stopRecording);

    } catch (e) {
      // _snack('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    // IF NOT RECORDING, CAN'T STOP RECORDING SO RETURN
    if (!_isRecording) return;

    // IF RECORD TIMER EXISTS, CANCEL IT
    _recordTimer?.cancel();

    try {

      // STOP RECORDER
      final path = await _recorder.stop();
      setState(() => _isRecording = false);

      // IF RECORDING FAILED, RETURN
      if (path == null) return;

      // just_audio can probe duration if we load the file
      Duration? dur;
      try {
        await _player.setFilePath(path);
        dur = _player.duration;
        await _player.stop();
      } catch (_) {}

      // CREATE NEW ATTEMPT AND STORE
      _attempts.insert(
        0,
        Attempt(
          word: _words[_index],
          filePath: path,
          durationMs: (dur ?? Duration.zero).inMilliseconds,
        ),
      );

      // UPDATE UI IF RECORD BUTTON IS ON SCREEN
      if (mounted) setState(() {});

      // _snack('Saved attempt for "${_words[_index]}"');
    } catch (e) {
      // _snack('Failed to stop recording: $e');
    }
  }

  // @override
  // void dispose() {
  //   _recordTimer?.cancel();
  //   _player.dispose();
  //   _recorder.cancel();
  //   super.dispose();
  // }

  Future<String> _nextPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/readright_${_words[_index]}_$ts.m4a';
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // print("Record Button Pressed");
        _startRecording();
      },
      // onPressed: (!_recorderReady || _isRecording)
      //     ? null
      //     : _startRecording,
      icon: const Icon(Icons.mic),
      label: const Text('Record'),
    );
  }
}

class Attempt {
  Attempt({
    required this.word,
    required this.filePath,
    required this.durationMs,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String word;
  final String filePath;
  final int durationMs;
  final DateTime createdAt;
}

/*
class Attempt {
  Attempt({
    required this.word,
    required this.filePath,
    required this.durationMs,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String word;
  final String filePath;
  final int durationMs;
  final DateTime createdAt;
}

class ReadRightHome extends StatefulWidget {
  const ReadRightHome({super.key});
  @override
  State<ReadRightHome> createState() => _ReadRightHomeState();
}

class _ReadRightHomeState extends State<ReadRightHome> {
  // Engines
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();

  bool _recorderReady = false;
  bool _isRecording = false;
  bool _isPlaying = false;

  final List<String> _words = const [
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
  int _index = 0;

  final List<Attempt> _attempts = [];
  static const int kMaxRecordMs = 7000;
  Timer? _recordTimer;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    // Ask for permission; on macOS this triggers the system prompt if not yet granted.
    final hasPerm = await _recorder.hasPermission();
    if (!hasPerm) {
      final granted = await _recorder
          .hasPermission(); // record doesn't expose a request; system will prompt on start()
      if (!granted && mounted) {
        _snack('Microphone permission is required.');
        return;
      }
    }
    setState(() => _recorderReady = true);
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    _player.dispose();
    _recorder.cancel();
    super.dispose();
  }

  Future<String> _nextPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/readright_${_words[_index]}_$ts.m4a';
  }

  Future<void> _startRecording() async {
    if (!_recorderReady || _isRecording) return;
    final path = await _nextPath();
    try {
      final config = RecordConfig(
        encoder: AudioEncoder.aacLc, // -> .m4a
        sampleRate: 44100,
        bitRate: 128000,
      );
      await _recorder.start(config, path: path);
      setState(() => _isRecording = true);

      _recordTimer?.cancel();
      _recordTimer =
          Timer(const Duration(milliseconds: kMaxRecordMs), _stopRecording);
    } catch (e) {
      _snack('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    _recordTimer?.cancel();

    try {
      final path = await _recorder.stop();
      setState(() => _isRecording = false);
      if (path == null) return;

      // just_audio can probe duration if we load the file
      Duration? dur;
      try {
        await _player.setFilePath(path);
        dur = _player.duration;
        await _player.stop();
      } catch (_) {}

      _attempts.insert(
        0,
        Attempt(
          word: _words[_index],
          filePath: path,
          durationMs: (dur ?? Duration.zero).inMilliseconds,
        ),
      );
      if (mounted) setState(() {});
      _snack('Saved attempt for "${_words[_index]}"');
    } catch (e) {
      _snack('Failed to stop recording: $e');
    }
  }

  Future<void> _play(String path) async {
    if (_isPlaying) return;
    try {
      await _player.setFilePath(path);
      await _player.play();
      setState(() => _isPlaying = true);
      _player.playerStateStream.listen((s) {
        if (s.processingState == ProcessingState.completed ||
            s.playing == false) {
          if (mounted) setState(() => _isPlaying = false);
        }
      });
    } catch (e) {
      _snack('Playback failed: $e');
    }
  }

  void _prevWord() {
    if (_isRecording) return;
    setState(() => _index = (_index - 1) < 0 ? _words.length - 1 : _index - 1);
  }

  void _nextWord() {
    if (_isRecording) return;
    setState(() => _index = (_index + 1) % _words.length);
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
  */