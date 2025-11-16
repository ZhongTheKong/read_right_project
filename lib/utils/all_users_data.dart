import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/teacher_user_data.dart';
import 'package:read_right_project/utils/user_data.dart';

class AllUserData {
  AllUserData({
    required this.lastLoggedInUser,
    // required this.userDataList,
    required this.studentUserDataList,
    required this.teacherUserDataList,
  });
  UserData? lastLoggedInUser;
  final List<StudentUserData> studentUserDataList;
  final List<TeacherUserData> teacherUserDataList;

  // final List<UserData> userDataList;

    // Deserialize
  factory AllUserData.fromJson(Map<String, dynamic> json) {
    return AllUserData(
      lastLoggedInUser: json['lastLoggedInUser'] != null ? UserData.fromJson(json['lastLoggedInUser']) : null,
      // attempts: json['attempts'],
      // userDataList: (json['userDataList'] as List<dynamic>)
      //     .map((a) => UserData.fromJson(a))
      //     .toList(),

      studentUserDataList: (json['studentUserDataList'] as List<dynamic>)
          .map((a) => StudentUserData.fromJson(a))
          .toList(),

      teacherUserDataList: (json['teacherUserDataList'] as List<dynamic>)
          .map((a) => TeacherUserData.fromJson(a))
          .toList(),
    );
  }

  // Serialize
  Map<String, dynamic> toJson() {
    return {
      'lastLoggedInUser': lastLoggedInUser?.toJson(),
      // 'userDataList': userDataList.map((a) => a.toJson()).toList(),
      'studentUserDataList': studentUserDataList.map((a) => a.toJson()).toList(),
      'teacherUserDataList': teacherUserDataList.map((a) => a.toJson()).toList(),


    };
  }
}