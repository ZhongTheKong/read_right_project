import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ReadRightApp());
}

class ReadRightApp extends StatelessWidget {
  const ReadRightApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReadRight — macOS Recorder Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      home: const ReadRightHome(),
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
    // TODO: Change this to not save to OneDrive/Documents
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/read_right/recordings/readright_${_words[_index]}_$ts.m4a';
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

  @override
  Widget build(BuildContext context) {
    final word = _words[_index];
    return Scaffold(
      appBar: AppBar(title: const Text('ReadRight — Record & Play (macOS)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: _prevWord,
                icon: const Icon(Icons.chevron_left, size: 32)),
            Column(children: [
              const Text('Say this word:', style: TextStyle(fontSize: 16)),
              Text(word,
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold)),
            ]),
            IconButton(
                onPressed: _nextWord,
                icon: const Icon(Icons.chevron_right, size: 32)),
          ]),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(_isRecording
                        ? 'Recording… (auto-stops at ${kMaxRecordMs ~/ 1000}s)'
                        : 'Ready to record up to ${kMaxRecordMs ~/ 1000}s'),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: (!_recorderReady || _isRecording)
                              ? null
                              : _startRecording,
                          icon: const Icon(Icons.mic),
                          label: const Text('Record'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isRecording ? _stopRecording : null,
                          icon: const Icon(Icons.stop),
                          label: const Text('Stop'),
                        ),
                      ),
                    ]),
                  ]),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _attempts.isEmpty
                ? const Center(
                    child: Text('No attempts yet. Record your first try!'))
                : ListView.separated(
                    itemCount: _attempts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final a = _attempts[i];
                      final exists = File(a.filePath).existsSync();
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(width: 0.5),
                        ),
                        title: Text('${a.word} — ${a.createdAt.toLocal()}'),
                        subtitle: Text(
                            'Duration: ~${(a.durationMs / 1000).toStringAsFixed(1)}s'),
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                            tooltip: 'Play',
                            onPressed: (!exists || _isPlaying)
                                ? null
                                : () => _play(a.filePath),
                            icon: const Icon(Icons.play_arrow),
                          ),
                          IconButton(
                            tooltip: 'Stop',
                            onPressed: _isPlaying
                                ? () => _player.stop().then(
                                    (_) => setState(() => _isPlaying = false))
                                : null,
                            icon: const Icon(Icons.stop),
                          ),
                        ]),
                      );
                    },
                  ),
          ),
        ]),
      ),
    );
  }
}
