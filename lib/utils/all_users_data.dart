import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/teacher_user_data.dart';
import 'package:read_right_project/utils/user_data.dart';

class AllUserData {
  AllUserData({
    this.lastLoggedInUserUsername,
    this.lastLoggedInUserIsTeacher,
    List<StudentUserData>? studentUserDataList,
    List<TeacherUserData>? teacherUserDataList,
  })  : studentUserDataList = studentUserDataList ?? [],
        teacherUserDataList = teacherUserDataList ?? [];

  String? lastLoggedInUserUsername;
  bool? lastLoggedInUserIsTeacher;

  bool isLastLoggedInUserOutdated = true;
  UserData? get lastLoggedInUser {
    if (isLastLoggedInUserOutdated && 
        lastLoggedInUserUsername != null && 
        lastLoggedInUserIsTeacher != null)
    {
      isLastLoggedInUserOutdated = false;
      print("Searching for last logged in user");
      if (lastLoggedInUserIsTeacher!)
      {
        _lastLoggedInUser = teacherUserDataList.firstWhere( (t) => t.username == lastLoggedInUserUsername);
      }
      else
      {
        _lastLoggedInUser = studentUserDataList.firstWhere( (s) => s.username == lastLoggedInUserUsername);
      }
    }
    return _lastLoggedInUser;
  }
  UserData? _lastLoggedInUser;
  final List<StudentUserData> studentUserDataList;
  final List<TeacherUserData> teacherUserDataList;

  // Deserialize
  factory AllUserData.fromJson(Map<String, dynamic> json) {

    try
    {
      String? lastLoggedInUserUsername = json['lastLoggedInUserUsername'];
      bool? lastLoggedInUserIsTeacher = json['lastLoggedInUserIsTeacher'];

      // Handle studentUserDataList safely
      final studentList = (json['studentUserDataList'] as List<dynamic>?)
              ?.map((a) => StudentUserData.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [];

      // Handle teacherUserDataList safely
      final teacherList = (json['teacherUserDataList'] as List<dynamic>?)
              ?.map((a) => TeacherUserData.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [];

      return AllUserData(
        lastLoggedInUserUsername: lastLoggedInUserUsername,
        lastLoggedInUserIsTeacher: lastLoggedInUserIsTeacher,
        studentUserDataList: studentList,
        teacherUserDataList: teacherList,
      );
    }
    on FormatException catch (e) {
      // Happens when JSON is malformed
      print("AllUserData.fromJSON | JSON format error: $e");

      // Optionally: rename the bad file so user doesn't get stuck
      throw Exception("Saved data file (AllUserData) is corrupted. ($e)");
    }
  }

  // Serialize
  Map<String, dynamic> toJson() {
    return {
      'lastLoggedInUserUsername': lastLoggedInUserUsername,
      'lastLoggedInUserIsTeacher': lastLoggedInUserIsTeacher,
      'studentUserDataList':
          studentUserDataList.map((a) => a.toJson()).toList(),
      'teacherUserDataList':
          teacherUserDataList.map((a) => a.toJson()).toList(),
    };
  }
}
