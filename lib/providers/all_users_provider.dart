import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_right_project/utils/all_users_data.dart';
import 'package:read_right_project/utils/user_data.dart';

class AllUsersProvider extends ChangeNotifier{

  AllUserData allUserData = AllUserData(lastLoggedInUser: null, userDataList: []);

  // UserData? lastLoggedInUser;
  // List<UserData> loadedUserDataList = [];

  // Future<UserData> getLoadedLastLoggedInUser() async {
  //   if (lastLoggedInUser == null) { 
  //     await loadUserData();
  //   }
  //   return lastLoggedInUser!;
  // }

  // Future<List<UserData>> getloadedUserDataList() async {
  //   if (loadedUserDataList.isEmpty) { 
  //     await loadUserData();
  //   }
  //   return loadedUserDataList;
  // }

  // Future<AllUserData> getAllUserData() async {
  //   if (allUserData == null) { 
  //     await loadUserData();
  //   }
  //   return allUserData!;
  // }

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
    // await file.writeAsString(jsonEncode(jsonList));
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

  // Future<void> saveUserData(List<UserData> allUserData) async {
  //   // TODO: Change this to not save to OneDrive/Documents
  //   final directory = await getApplicationDocumentsDirectory();

  //   final saveDir = Directory('${directory.path}/read_right/save_data');

  //   // Create directory if it doesn't exist
  //   if (!await saveDir.exists()) {
  //     await saveDir.create(recursive: true); // recursive = true creates parent dirs too
  //   }

  //   final file = File('${saveDir.path}/all_user_data.json');
  //   print("Saving data to ${file.path}");

  //   final jsonList = allUserData.map((u) => u.toJson()).toList();
  //   const encoder = JsonEncoder.withIndent('  ');
  //   final prettyString = encoder.convert(jsonList);

  //   await file.writeAsString(prettyString);
  //   // await file.writeAsString(jsonEncode(jsonList));
  // }

  // Future<void> loadUserData() async {
  //   // TODO: Change this to not save to OneDrive/Documents
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/read_right/save_data/userdata.json');

  //   if (!file.existsSync()) return;

  //   final content = await file.readAsString();
  //   final data = jsonDecode(content) as List<dynamic>;

  //   loadedAllUserData = data.map((u) => UserData.fromJson(u)).toList();
  //   // return UserData.fromJson(jsonDecode(content));
  // }

    // Load the username from local storage
  // Future<void> loadLastUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   _username = prefs.getString('lastUser_username') ?? 'Guest';
  //   isTeacher = prefs.getBool('lastUser_isTeacher') ?? false;
  //   notifyListeners();
  //   // return _username;
  // }

  void clearLastUser() async {
    allUserData.lastLoggedInUser = null;
    saveUserData(allUserData!);
    notifyListeners();
  }

  // Save the username to local storage
  Future<void> saveLastUser(UserData lastUser) async {
    allUserData.lastLoggedInUser = lastUser;
    saveUserData(allUserData!);
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('lastUser_username', username);
    // await prefs.setBool('lastUser_isTeacher', isTeacher);
    // _username = username;
    // isTeacher = isTeacher;
    notifyListeners();
  }

}