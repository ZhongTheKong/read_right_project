import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_right_project/utils/all_users_data.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/user_data.dart';
import 'package:read_right_project/utils/word_list_progression_data.dart';

class AllUsersProvider extends ChangeNotifier{

  AllUserData allUserData = AllUserData(lastLoggedInUserUsername: null, lastLoggedInUserIsTeacher: null, studentUserDataList: [], teacherUserDataList: []);
  bool isSynced = false;

  Future<String> getUserDataFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    final saveDir = Directory('${directory.path}/read_right/save_data');
    // Create directory if it doesn't exist
    if (!await saveDir.exists()) {
      await saveDir.create(recursive: true); // recursive = true creates parent dirs too
    }

    return '${saveDir.path}/all_user_data.json';
  }

  Future<void> saveUserData(String filePath, AllUserData allUserData) async {
    final file = File(filePath);
    print("Saving data to ${file.path}");

    final jsonList = allUserData.toJson();
    const encoder = JsonEncoder.withIndent('  ');
    final prettyString = encoder.convert(jsonList);

    await file.writeAsString(prettyString);
  }

  Future<void> saveCurrentUserData() async {
    await saveUserData(await getUserDataFilePath(), allUserData);
  }

  Future<void> loadUserData(String filePath) async {
    final file = File(filePath);

    if (!file.existsSync()) {
      print("File does not exist");
      throw Exception("User data file does not exist.");
    }

    try
    {
      final content = await file.readAsString();
      print("Loaded json:\n$content");
      final data = jsonDecode(content);

      allUserData = AllUserData.fromJson(data);
      // return UserData.fromJson(jsonDecode(content));
    } on FormatException catch (e) {
      // Happens when JSON is malformed
      print("JSON format error: $e");

      // Optionally: rename the bad file so user doesn't get stuck
      await _quarantineCorruptFile(file);
      throw Exception("Saved data file is corrupted. ($e)");
    } catch (e, stack) {
      // Catch-all (e.g. fromJson exceptions)
      print("Unexpected error loading user data: $e\n$stack");
      rethrow;
    }
    isSynced = true;
    notifyListeners();
  }

  void clearLastUser() async {
    // allUserData.lastLoggedInUser = null;
    allUserData.lastLoggedInUserUsername = null;
    allUserData.lastLoggedInUserIsTeacher = null;
    saveCurrentUserData();
    notifyListeners();
  }

  // Save the username to local storage
  Future<void> saveLastUser(UserData lastUser) async {
    // allUserData.lastLoggedInUser = lastUser;
    allUserData.lastLoggedInUserUsername = lastUser.username;
    allUserData.lastLoggedInUserIsTeacher = lastUser.isTeacher;
    allUserData.isLastLoggedInUserOutdated = true;

    print("Last logged in user username = ${allUserData.lastLoggedInUserUsername}");
    print("Last logged in user isTeacher = ${allUserData.lastLoggedInUserIsTeacher}");
    saveCurrentUserData();
    notifyListeners();
  }

  Future<void> _quarantineCorruptFile(File file) async {
    final corruptPath = file.path + ".corrupt_${DateTime.now().millisecondsSinceEpoch}";
    await file.rename(corruptPath);
    print("Corrupt JSON moved to: $corruptPath");
  }

  Future<void> quarantineCorruptFile() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/read_right/save_data/all_user_data.json');

    if (!file.existsSync()) {
      print("File does not exist");
      return;
    }
    final corruptPath = file.path + ".corrupt_${DateTime.now().millisecondsSinceEpoch}";
    await file.rename(corruptPath);
    print("Corrupt JSON moved to: $corruptPath");
  }

  Future<void> deleteUserData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final saveDir = Directory('${directory.path}/read_right/save_data');
      final file = File('${saveDir.path}/all_user_data.json');

      if (!await file.exists()) {
        throw Exception("No user data file found to delete.");
      }

      await file.delete();
      print("User data deleted at: ${file.path}");

    } catch (e) {
      print("Error deleting user data: $e");
      throw Exception("Failed to delete user data: $e");
    }
  }

  Future<bool> doesSaveFileExist() async {
    final directory = await getApplicationDocumentsDirectory();
    final saveDir = Directory('${directory.path}/read_right/save_data');
    final file = File('${saveDir.path}/all_user_data.json');

    if (!await file.exists()) {
      return false;
    }
    return true;
  }

  int getWordListCurrIndex(String wordListFileName) {
    StudentUserData? student;
    if (
      allUserData.lastLoggedInUser != null && 
      allUserData.lastLoggedInUser! is StudentUserData
    ) {
      student = allUserData.lastLoggedInUser as StudentUserData;
    }
    final WordListProgressionData? wordListProgressionData = student?.word_list_progression_data[wordListFileName];
    int wordIndex = 0;
    if (wordListProgressionData != null) {
      wordIndex = wordListProgressionData.currIndex;
    }
    return wordIndex;
  }

  void incrementCurrIndex(String wordListFileName) {
    final currentUser = allUserData.lastLoggedInUser;
    final StudentUserData? student = currentUser is StudentUserData ? currentUser : null;
    final WordListProgressionData? wordListProgressionData =
        student?.word_list_progression_data[wordListFileName];
    if (wordListProgressionData != null) {
      wordListProgressionData.currIndex++;
    }
    notifyListeners();
  }


}