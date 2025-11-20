import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_right_project/utils/all_users_data.dart';
import 'package:read_right_project/utils/user_data.dart';

class AllUsersProvider extends ChangeNotifier{

  AllUserData allUserData = AllUserData(lastLoggedInUser: null, studentUserDataList: [], teacherUserDataList: []);

  Future<void> saveUserData(AllUserData allUserData) async {
    // TODO: Change this to not save to OneDrive/Documents
    final directory = await getApplicationDocumentsDirectory();

    final saveDir = Directory('${directory.path}/read_right/save_data');

    // Create directory if it doesn't exist
    if (!await saveDir.exists()) {
      await saveDir.create(recursive: true); // recursive = true creates parent dirs too
    }

    final file = File('${saveDir.path}/all_user_data.json');
    print("Saving data to ${file.path}");

    final jsonList = allUserData.toJson();
    const encoder = JsonEncoder.withIndent('  ');
    final prettyString = encoder.convert(jsonList);

    await file.writeAsString(prettyString);
  }

  Future<void> saveCurrentUserData() async {
    await saveUserData(allUserData);
  }

  Future<void> loadUserData() async {
    // TODO: Change this to not save to OneDrive/Documents
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/read_right/save_data/all_user_data.json');

    if (!file.existsSync()) {
      print("File does not exist");
      await saveUserData(allUserData);
      // throw Exception("User data file does not exist.");
      // return;
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
      // rethrow;
      throw Exception("Unexpected error loading user data: $e");
    }
  }

  void clearLastUser() async {
    allUserData.lastLoggedInUser = null;
    saveUserData(allUserData);
    notifyListeners();
  }

  // Save the username to local storage
  Future<void> saveLastUser(UserData lastUser) async {
    allUserData.lastLoggedInUser = lastUser;
    saveUserData(allUserData);
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
      // throw Exception("User data file does not exist.");
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


}