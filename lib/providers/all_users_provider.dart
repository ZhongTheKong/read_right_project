import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_right_project/utils/user_data.dart';

class AllUsersProvider extends ChangeNotifier{

  List<UserData> loadedAllUserData = [];

  Future<List<UserData>> getLoadedAllUserData() async {
    if (loadedAllUserData.isEmpty) { 
      await loadUserData();
    }
    return loadedAllUserData;
  }

  Future<void> saveUserData(List<UserData> allUserData) async {
    // TODO: Change this to not save to OneDrive/Documents
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/save_data/all_user_data.json');
    print("Saving data to ${directory.path}/}/save_data/all_user_data.json");

    final jsonList = allUserData.map((u) => u.toJson()).toList();
    const encoder = JsonEncoder.withIndent('  ');
    final prettyString = encoder.convert(jsonList);

    await file.writeAsString(prettyString);
    // await file.writeAsString(jsonEncode(jsonList));
  }

  Future<void> loadUserData() async {
    // TODO: Change this to not save to OneDrive/Documents
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/}/save_data/userdata.json');

  if (!file.existsSync()) return;

  final content = await file.readAsString();
  final data = jsonDecode(content) as List<dynamic>;

  loadedAllUserData = data.map((u) => UserData.fromJson(u)).toList();
  // return UserData.fromJson(jsonDecode(content));
}

}