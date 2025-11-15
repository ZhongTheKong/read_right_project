import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_right_project/utils/attempt.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';

class SessionProvider extends ChangeNotifier {
  final recorder = AudioRecorder();
  final player = AudioPlayer();
  late stt.SpeechToText _speech; // STT instance

  bool recorderReady = false;
  bool isRecording = false;
  bool isPlaying = false;
  bool isTranscribing = false;

  final List<String> word_list = const [
    'round',
    'small',
    'grow',
    'sleep',
    'again',
    'fly',
    'because',
    'must',
    'always',
    'saw',
    'keep',
    'bake_cake',
    'car_tar',
    'bat_back',
    'date_gate',
    'sink_think',
    'reed_weed',
    'sit_sick',
    'fan_van',
    'free_three',
    'goo_glue',
    'see_seed'
  ];
  int index = 0;
  int selectedIndex = 0;

  int sentenceIndex = 0;
  String selectedWord = '';

  /// Placeholder for CSV file parsing
  final Map<String, String> sentence_list = const {
    'round1': 'The circle is round',
    'round2': 'Time for round two',
    'small1': 'The dog is small',
    'small2': 'Bugs are small',
    'grow1': 'You can grow by drinking milk',
    'grow2': 'Kids grow up fast',
    'sleep1': 'Sleep for eight hours',
    'sleep2': 'You should sleep when it is night',
    'again1': 'Do it again',
    'again2': 'Mom baked cookies again',
    'fly1': 'Birds fly',
    'fly2': 'People cannot fly',
    'because1': 'You eat fruits because they are good for you',
    'because2': 'You do not talk to strangers because they are dangerous',
    'must1': 'You must look both ways before crossing the street',
    'must2': 'You must wash your hands after using the bathroom',
    'always1': 'Always brush your teeth',
    'always2': 'You always know what to say',
    'saw1': 'Dad cut some wood with a saw',
    'saw2': 'I saw a shooting star',
    'keep1': 'Keep trying and you will succeed',
    'keep2': 'Keep up the good work',
    'bake_cake1': 'Bake the cake in the oven',
    'bake_cake2': 'Bake at high temperature to get a cake',
    'car_tar1': 'Drive your car and stay out of tar',
    'car_tar2': 'Tar is bad for your car',
    'bat_back1': 'Take the bat around back',
    'bat_back2': 'The back of a bat is brown',
    'date_gate1': 'Open the gate on the right date',
    'date_gate2': 'On this date they will build the gate',
    'sink_think1': 'Think in the sink',
    'sink_think2': 'You will sink if you don\'t think',
    'reed_weed1': 'A reed is a weed',
    'reed_weed2': 'Not every weed is a reed',
    'sit_sick1': 'You must sit and rest when you are sick',
    'sit_sick2': 'Sick days mean you sit at home',
    'fan_van1': 'A van gets hot without a fan',
    'fan_van2': 'There is a fan in the van',
    'free_three1': 'Buy one get three free',
    'free_three2': 'Three free birds',
    'goo_glue1': 'Glue is a kind of goo',
    'goo_glue2': 'Not all goo is glue',
    'see_seed1': 'See the seed grow',
    'see_seed2': 'The seed cannot see you',
  };

  final List<Attempt> attempts = [];
  static const int kMaxRecordMs = 7000;
  Timer? recordTimer;
  int elapsedMs = 0;
  // To keep track of the current logged in user
  String _username = 'Guest';


  static const int intervalMs = 50;

  // Calculate average score
  double get averageScore {
    if (attempts.isEmpty) return 0.0;
    final totalScore = attempts.fold(0.0, (sum, attempt) => sum + attempt.score);
    return totalScore / attempts.length;
  }

  int get numberOfAttempts => attempts.length;

  String get currentUser => _username;

  /// Currently needed to get progress screen to persist
  SessionProvider() {
    _loadUsername();
  }

  // Future<void> initAudio(bool mounted) async {
  //   final hasPerm = await recorder.hasPermission();
  //   if (!hasPerm) {
  //     final granted = await recorder.hasPermission();
  //     if (!granted && mounted) return;
  //   }
  //   recorderReady = true;

  //   _speech = stt.SpeechToText();

  //   await _loadUsername();

  //   notifyListeners();
  // }

  // Load the username from local storage
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('lastUser') ?? 'Guest';
    notifyListeners();

  }

  // Save the username to local storage
  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastUser', username);
    _username = username;
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

  // Future<void> startRecording() async {
  //   if (!recorderReady || isRecording) return;
    
  //   final path = await _nextPath();

  //   try {
  //     final config = RecordConfig(
  //       encoder: AudioEncoder.wav,
  //       sampleRate: 44100,
  //       bitRate: 128000,
  //     );

  //     await recorder.start(config, path: path);
  //     isRecording = true;
  //     // Start automatic transcription after recording
  //     // await transcribeAudio(path);
  //     notifyListeners();

  //     recordTimer?.cancel();
  //     recordTimer = Timer(const Duration(milliseconds: kMaxRecordMs), () => stopRecording());

  //     recordTimer = Timer.periodic(
  //       const Duration(milliseconds: intervalMs),
  //       (timer) {
  //         elapsedMs = timer.tick * intervalMs;
  //         if (elapsedMs >= kMaxRecordMs) {
  //           elapsedMs = kMaxRecordMs;
  //           recordTimer?.cancel();
  //         }
  //         notifyListeners();
  //       },
  //     );
  //   } catch (e) {}
  // }

  // Future<void> stopRecording() async {
  //   if (!isRecording) return;
  //   recordTimer?.cancel();

  //   try {
  //     final path = await recorder.stop();
  //     isRecording = false;
  //     notifyListeners();
  //     if (path == null) return;

  //     Duration? dur;
  //     try {
  //       await player.setFilePath(path);
  //       dur = player.duration;
  //       await player.stop();
  //     } catch (_) {}

  //     // Save attempt
  //     attempts.insert(
  //       0,
  //       Attempt(
  //         word: word_list[index],
  //         score: elapsedMs / kMaxRecordMs, // Placeholder for score
  //         filePath: path,
  //         durationMs: (dur ?? Duration.zero).inMilliseconds,
  //       ),
  //     );
  //     notifyListeners();


  //   } catch (e) {}
  // }

  // Future<void> play(String path) async {
  //   if (isPlaying) return;
  //   try {
  //     await player.setFilePath(path);
  //     await player.play();
  //     isPlaying = true;
  //     notifyListeners();

  //     player.playerStateStream.listen((s) {
  //       if (s.processingState == ProcessingState.completed || s.playing == false) {
  //         isPlaying = false;
  //         notifyListeners();
  //       }
  //     });
  //   } catch (e) {}
  // }

  void incrementIndex(int increment) {
    if (isRecording) return;
    index = (index + increment) % word_list.length;
    notifyListeners();
  }

  void selectWord(String word) {
    sentenceIndex = 0;
    selectedWord = word;
    notifyListeners();
  }

  void changeSentence() {
    if(sentenceIndex == 0) {sentenceIndex = 1;}
    else {sentenceIndex = 0;}
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
          /// Compare result.recognizedWords with the word_list[index]

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
