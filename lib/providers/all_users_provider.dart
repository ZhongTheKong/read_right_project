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
      return;
    }

    final content = await file.readAsString();
    print("Loaded json:\n$content");
    final data = jsonDecode(content);

    allUserData = AllUserData.fromJson(data);
    // return UserData.fromJson(jsonDecode(content));
  }

  void clearLastUser() async {
    allUserData.lastLoggedInUser = null;
    saveUserData(allUserData!);
    notifyListeners();
  }

  // Save the username to local storage
  Future<void> saveLastUser(UserData lastUser) async {
    allUserData.lastLoggedInUser = lastUser;
    saveUserData(allUserData!);
    notifyListeners();
  }

}