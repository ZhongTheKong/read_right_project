import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // Import rootBundle
import 'package:csv/csv.dart'; // Import the CSV package
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/utils/attempt.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/word_list_progression_data.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_right_project/utils/word.dart';


class SessionProvider extends ChangeNotifier {
  // final recorder = AudioRecorder();
  // final player = AudioPlayer();
  late stt.SpeechToText _speech; // STT instance

  // bool recorderReady = false;
  // bool isRecording = false;
  // bool isPlaying = false;
  bool isTranscribing = false;

  bool isTeacher = false;

  List<Word> word_list = [];
  int index = 0;
  int selectedIndex = 0;
  String grade = "Pre-Primer";
  bool _wordsLoaded = false;
  bool listComplete = false;

  String word_list_name = '';

  // final List<Attempt> attempts = [];
  // static const int kMaxRecordMs = 7000;
  // Timer? recordTimer;
  // int elapsedMs = 0;
  // To keep track of the current logged in user
  String _username = 'Guest';


  // static const int intervalMs = 50;

  // Calculate average score
  // double get averageScore {
  //   if (attempts.isEmpty) return 0.0;
  //   final totalScore = attempts.fold(0.0, (sum, attempt) => sum + attempt.score);
  //   return totalScore / attempts.length;
  // }

  // int get numberOfAttempts => attempts.length;

  // String get currentUser => _username;

  // String get word => word_list[index].text;
  // String get grade_level => word_list[index].grade;

  /// Currently needed to get progress screen to persist
  SessionProvider() {
    loadUsername();
    loadIndex();
  }

  /// Functions to load and save the index in the word list
  /// Likely will be replaced once attempt persistence is implemented
  Future<void> loadIndex() async {
    final prefs = await SharedPreferences.getInstance();
    index = prefs.getInt('lastIndex') ?? 0;
    notifyListeners();
  }

  Future<void> saveIndex() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastIndex', index);
  }

  /// Index saving was added. Likely will be replaced once attempt persistence
  /// is added.
  // TODO: loadUsername and ready speech to text need to be initialized somewhere else
  Future<void> loadWordList(String path) async {
    if (_wordsLoaded) return;
    await loadIndex();
    try {
      final fileData = await rootBundle.loadString(path);
      // Use CsvToListConverter to parse the CSV string.
      List<List<dynamic>> csvTable = const CsvToListConverter(eol: '\n').convert(fileData);

      final List<Word> loadedWords = [];
      // Start from index 1 to skip the header row.
      for (var i = 1; i < csvTable.length; i++) {
        final row = csvTable[i];
        // Ensure the row has at least two columns.
        if (row.length > 1) {
          final grade = row[0].toString().trim(); // Grade is in the first column (index 0)
          final wordText = row[1].toString().trim(); // Word is in the second column (index 1)
          if (grade.isNotEmpty && wordText.isNotEmpty) {
            // Create a Word object and add it to the list.
            loadedWords.add(Word(grade: grade, text: wordText));
          }
        }
      }

      // Update the state with the new list of Word objects.
      word_list = loadedWords;
      word_list_name = path;
      await saveIndex();

      // Notify listeners to rebuild widgets that use this provider.
      notifyListeners();
    } catch (e) {
      print('Error loading or parsing CSV file: $e');
      // In case of an error, ensure the word list is empty.
      word_list = [];
      notifyListeners();
    }
  }

  void incrementIndex(int increment) {
    if (word_list.isEmpty) return;
    index = (index + increment) % word_list.length;
    saveIndex();
    print('Grade: ${word_list[index].grade} ${listComplete}');
    notifyListeners();
  }

  /// Moves to the next word to practice. Also keeps track of if a list has been
  /// completed.
  // void nextWord(String isCorrect, bool updateList) {
    void nextWord(bool updateList) {
    if (word_list.isEmpty) return;
    if (!updateList) {
      listComplete = false;
      notifyListeners();
    }
    // if (isCorrect != 'Needs work') {
      String prev = word_list[index].grade;
      incrementIndex(1);

          
      print('Next word: ${word_list[index].text}');
      if (prev != word_list[index].grade) {
        listComplete = true;
        notifyListeners();
      }
      else {
        listComplete = false;
        notifyListeners();
      }
    // }
    // else {
    //   listComplete = false;
    //   notifyListeners();
    // }
  }

  // Load the username from local storage
  Future<String> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('lastUser') ?? 'Guest';
    notifyListeners();
    return _username;
  }

  void clearUsername() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("lastUser");
    notifyListeners();
  }

  // Save the username to local storage
  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastUser', username);
    _username = username;
    notifyListeners();
  }

  // @override
  // void dispose() {
  //   recordTimer?.cancel();
  //   player.dispose();
  //   recorder.cancel();
  //   super.dispose();
  // }

  Future<String> _nextPath() async {
    // TODO: Change this to not save to OneDrive/Documents
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/read_right/recordings/readright_${word_list[index]}_$ts.wav';
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
