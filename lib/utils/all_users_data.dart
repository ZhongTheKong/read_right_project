// import 'package:read_right_project/utils/student_user_data.dart';
// import 'package:read_right_project/utils/teacher_user_data.dart';
// import 'package:read_right_project/utils/user_data.dart';

// class AllUserData {
//   AllUserData({
//     required this.lastLoggedInUser,
//     // required this.userDataList,
//     required this.studentUserDataList,
//     required this.teacherUserDataList,
//   });
//   UserData? lastLoggedInUser;
//   final List<StudentUserData> studentUserDataList;
//   final List<TeacherUserData> teacherUserDataList;

//   // final List<UserData> userDataList;

//   // Deserialize
//   factory AllUserData.fromJson(Map<String, dynamic> json) {

//     UserData? lastLoggedInUser;
//     if (json['lastLoggedInUser'] != null)
//     {
//       final lastJson = json['lastLoggedInUser'] as Map<String, dynamic>;
//       if (lastJson['isTeacher'] == true)
//       {
//         lastLoggedInUser = TeacherUserData.fromJson(lastJson);
//       }
//       else
//       {
//         lastLoggedInUser = StudentUserData.fromJson(lastJson);
//       }
//     }


//     return AllUserData(
//       lastLoggedInUser: lastLoggedInUser,
//       // attempts: json['attempts'],
//       // userDataList: (json['userDataList'] as List<dynamic>)
//       //     .map((a) => UserData.fromJson(a))
//       //     .toList(),

//       studentUserDataList: (json['studentUserDataList'] as List<dynamic>)
//           .map((a) => StudentUserData.fromJson(a))
//           .toList(),

//       teacherUserDataList: (json['teacherUserDataList'] as List<dynamic>)
//           .map((a) => TeacherUserData.fromJson(a))
//           .toList(),
//     );
//   }

//   // Serialize
//   Map<String, dynamic> toJson() {
//     return {
//       'lastLoggedInUser': lastLoggedInUser?.toJson(),
//       // 'userDataList': userDataList.map((a) => a.toJson()).toList(),
//       'studentUserDataList': studentUserDataList.map((a) => a.toJson()).toList(),
//       'teacherUserDataList': teacherUserDataList.map((a) => a.toJson()).toList(),


//     };
//   }
// }

import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/teacher_user_data.dart';
import 'package:read_right_project/utils/user_data.dart';

class AllUserData {
  AllUserData({
    // this.lastLoggedInUser,
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
    // else
    // {
    //   print("Cannot search for last logged in user");
    //   if (_lastLoggedInUser != null)
    //   {
    //     print("Last logged in user already found");
    //   }
    //   if (lastLoggedInUserUsername == null)
    //   {
    //     print("Last logged in username is missing");
    //   }
    //   if (lastLoggedInUserIsTeacher == null)
    //   {
    //     print("Last logged in isTeacher is missing");
    //   }
    // }
    return _lastLoggedInUser;
  }
  UserData? _lastLoggedInUser;
  // UserData? lastLoggedInUser;
  final List<StudentUserData> studentUserDataList;
  final List<TeacherUserData> teacherUserDataList;

  // Deserialize
  factory AllUserData.fromJson(Map<String, dynamic> json) {

    try
    {
      // Handle lastLoggedInUser safely
      // UserData? lastLoggedInUser;
      // if (json['lastLoggedInUser'] != null) {
      //   final lastJson = json['lastLoggedInUser'] as Map<String, dynamic>;
      //   if (lastJson['isTeacher'] == true) {
      //     lastLoggedInUser = TeacherUserData.fromJson(lastJson);
      //   } else {
      //     lastLoggedInUser = StudentUserData.fromJson(lastJson);
      //   }
      // }
      String? lastLoggedInUserUsername = json['lastLoggedInUserUsername'];
      // print("AllUserData.fromJson: lastLoggedInUserUsername = ${lastLoggedInUserUsername}");
      bool? lastLoggedInUserIsTeacher = json['lastLoggedInUserIsTeacher'];
      // print("AllUserData.fromJson: lastLoggedInUserIsTeacher = ${lastLoggedInUserIsTeacher}");

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
        // lastLoggedInUser: lastLoggedInUser,
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
      // 'lastLoggedInUser': lastLoggedInUser?.toJson(),
      'lastLoggedInUserUsername': lastLoggedInUserUsername,
      'lastLoggedInUserIsTeacher': lastLoggedInUserIsTeacher,
      'studentUserDataList':
          studentUserDataList.map((a) => a.toJson()).toList(),
      'teacherUserDataList':
          teacherUserDataList.map((a) => a.toJson()).toList(),
    };
  }
}
