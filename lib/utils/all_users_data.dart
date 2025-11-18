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
    this.lastLoggedInUser,
    List<StudentUserData>? studentUserDataList,
    List<TeacherUserData>? teacherUserDataList,
  })  : studentUserDataList = studentUserDataList ?? [],
        teacherUserDataList = teacherUserDataList ?? [];

  UserData? lastLoggedInUser;
  final List<StudentUserData> studentUserDataList;
  final List<TeacherUserData> teacherUserDataList;

  // Deserialize
  factory AllUserData.fromJson(Map<String, dynamic> json) {
    // Handle lastLoggedInUser safely
    UserData? lastLoggedInUser;
    if (json['lastLoggedInUser'] != null) {
      final lastJson = json['lastLoggedInUser'] as Map<String, dynamic>;
      if (lastJson['isTeacher'] == true) {
        lastLoggedInUser = TeacherUserData.fromJson(lastJson);
      } else {
        lastLoggedInUser = StudentUserData.fromJson(lastJson);
      }
    }

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
      lastLoggedInUser: lastLoggedInUser,
      studentUserDataList: studentList,
      teacherUserDataList: teacherList,
    );
  }

  // Serialize
  Map<String, dynamic> toJson() {
    return {
      'lastLoggedInUser': lastLoggedInUser?.toJson(),
      'studentUserDataList':
          studentUserDataList.map((a) => a.toJson()).toList(),
      'teacherUserDataList':
          teacherUserDataList.map((a) => a.toJson()).toList(),
    };
  }
}
