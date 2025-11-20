import 'package:read_right_project/utils/user_data.dart';

class TeacherUserData extends UserData {
  TeacherUserData({
    required super.username,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.isTeacher,
    required this.studentUsernames,
  });
  final List<String> studentUsernames;

  // Deserialize
  factory TeacherUserData.fromJson(Map<String, dynamic> json) {
    try
    {
      return TeacherUserData(
        username: json['username'] ?? "",
        password: json['password'] ?? "",
        firstName: json['firstName'] ?? "",
        lastName: json['lastName'] ?? "",
        isTeacher: json['isTeacher'] ?? true,
        studentUsernames: json['studentUsernames'] != null ? 
          (json['studentUsernames'] as List<dynamic>)
              .map((e) => e.toString())
              .toList()
          : []
      );
    }
    on FormatException catch (e) {
      // Happens when JSON is malformed
      print("TeacherUserData.fromJSON | JSON format error: $e");

      // Optionally: rename the bad file so user doesn't get stuck
      throw Exception("Saved data file (TeacherUserData) is corrupted. ($e)");
    }
  }

  // Serialize
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'isTeacher': isTeacher,
      'studentUsernames': studentUsernames,
      // 'attempts': attempts.map((a) => a.toJson()).toList(),
    };
  }
}