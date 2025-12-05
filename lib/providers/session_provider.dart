import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // Import rootBundle
import 'package:csv/csv.dart'; // Import the CSV package
import 'package:path_provider/path_provider.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_right_project/utils/word.dart';


class SessionProvider extends ChangeNotifier {
  late stt.SpeechToText _speech; // STT instance

  bool isTranscribing = false;

  bool isTeacher = false;
  bool isCreateAccountTeacher = false;

  // List<Word> word_list = [];
  List<(String, List<String>)> word_list = [];

  int index = 0;
  int selectedIndex = 0;
  String grade = "Pre-Primer";
  bool _wordsLoaded = false;
  bool listComplete = false;

  String word_list_name = '';

  // To keep track of the current logged in user
  String _username = 'Guest';

  StudentUserData? teacherDashboardSelectedStudent = null;

  List<String> wordListFilePaths = [
    'assets/pre_primer_dolch.csv',
    'assets/primer_dolch.csv',
    'assets/first_dolch.csv',
    'assets/second_dolch.csv',
    'assets/third_dolch.csv',

  ];
  int currWordListIndex = 0;
  String get currWordListPath => wordListFilePaths[currWordListIndex];


  // /// Currently needed to get progress screen to persist
  // SessionProvider() {
  //   // loadUsername();
  //   loadIndex();
  // }

  // /// Functions to load and save the index in the word list
  // /// Likely will be replaced once attempt persistence is implemented
  // Future<void> loadIndex() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   index = prefs.getInt('lastIndex') ?? 0;
  //   notifyListeners();
  // }

  // Future<void> saveIndex() async {
  //   final prefs = await SharedPreferences.getInstance();
  //  
  // await prefs.setInt('lastIndex', index);
  // }

  // Future<void> loadWordList(String path, int currIndex) async {
  //   if (_wordsLoaded) return;
  //   index = currIndex;
  //   // await loadIndex();
  //   try {
  //     final fileData = await rootBundle.loadString(path);
  //     // Use CsvToListConverter to parse the CSV string.
  //     List<List<dynamic>> csvTable = const CsvToListConverter(eol: '\n').convert(fileData);

  //     final List<Word> loadedWords = [];
  //     // Start from index 1 to skip the header row.
  //     for (var i = 1; i < csvTable.length; i++) {
  //       final row = csvTable[i];
  //       // Ensure the row has at least two columns.
  //       if (row.length > 1) {
  //         final grade = row[0].toString().trim(); // Grade is in the first column (index 0)
  //         final wordText = row[1].toString().trim(); // Word is in the second column (index 1)
  //         if (grade.isNotEmpty && wordText.isNotEmpty) {
  //           // Create a Word object and add it to the list.
  //           loadedWords.add(Word(grade: grade, text: wordText));
  //         }
  //       }
  //     }

  //     // Update the state with the new list of Word objects.
  //     word_list = loadedWords;
  //     word_list_name = path;
  //     // await saveIndex();

  //     // Notify listeners to rebuild widgets that use this provider.
  //     notifyListeners();
  //   } catch (e) {
  //     print('Error loading or parsing CSV file: $e');
  //     // In case of an error, ensure the word list is empty.
  //     word_list = [];
  //     notifyListeners();
  //   }
  // }

  Future<void> loadWordList(String path, int currIndex) async {
    if (_wordsLoaded) return;
    index = currIndex;
    // await loadIndex();
    try {
      final fileData = await rootBundle.loadString(path);
      // Use CsvToListConverter to parse the CSV string.
      List<List<dynamic>> csvTable = const CsvToListConverter(eol: '\n').convert(fileData);

      final String trueWordListName = csvTable[0][1];
      // final List<Word> loadedWords = [];
      // List<(String, List<String>)> loadedWords = [];
      List<(String, List<String>)> new_word_list = [];

      // Start from index 1 to skip the header row.
      for (var i = 2; i < csvTable.length; i++) {
        final row = csvTable[i];
        // Ensure the row has at least two columns.
        if (row.length > 1) {
          // final grade = row[0].toString().trim(); // Grade is in the first column (index 0)
          final wordText = row[0].toString().trim(); // Word is in the second column (index 1)
          final sentencesText = row[1].toString().trim();
          if (grade.isNotEmpty && wordText.isNotEmpty) {
            // Create a Word object and add it to the list.
            new_word_list.add( (wordText, sentencesText.split(r'\')) );
          }
        }
      }

      // Update the state with the new list of Word objects.
      // word_list = loadedWords;
      word_list = new_word_list;

      word_list_name = path;
      // await saveIndex();

      // Notify listeners to rebuild widgets that use this provider.
      notifyListeners();
    } catch (e) {
      print('Error loading or parsing CSV file: $e');
      // In case of an error, ensure the word list is empty.
      word_list = [];
      notifyListeners();
    }
  }

  // void incrementIndex(int increment) {
  //   if (word_list.isEmpty) return;
  //   print("$index = ($index + $increment) % ${word_list.length}");
  //   index = (index + increment) % word_list.length;
  //   print("Index: $index");

  //   // saveIndex();
  //   // print('Grade: ${word_list[index].grade} ${listComplete}');
  //   notifyListeners();
  // }

  /// Moves to the next word to practice. Also keeps track of if a list has been
  /// completed.
  // void nextWord(bool updateList) {
  void updateIndex(int newIndex) {
  
    // if (word_list.isEmpty) {
    //   print("Word list is empty. Cannot move onto next word.");
    //   return;
    // }
    // if (!updateList) {
    //   print("Not set to update the list. List is not complete");
    //   listComplete = false;
    //   notifyListeners();
    // }
      // String prev = word_list[index].grade;
      // incrementIndex(1);

      index = newIndex;

      // print('Next word: ${word_list[index].text}');
      // if (prev != word_list[index].grade) {
      if (index > word_list.length - 1) {
        print("End of list reached");
        listComplete = true;
      }
      else {
        print("End of list not reached");
        listComplete = false;
      }
      notifyListeners();

  }

  // // Load the username from local storage
  // Future<String> loadUsername() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   _username = prefs.getString('lastUser') ?? 'Guest';
  //   notifyListeners();
  //   return _username;
  // }

  // void clearUsername() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.remove("lastUser");
  //   notifyListeners();
  // }

  // // Save the username to local storage
  // Future<void> saveUsername(String username) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('lastUser', username);
  //   _username = username;
  //   notifyListeners();
  // }

  Future<String> _nextPath() async {
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
