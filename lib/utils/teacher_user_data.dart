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
    return TeacherUserData(
      username: json['username'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      isTeacher: json['isTeacher'],
      studentUsernames: (json['studentUsernames'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),

      // isTeacher: json['isTeacher'],
      // attempts: json['attempts'],
      // attempts: (json['attempts'] as List<dynamic>)
      //     .map((a) => Attempt.fromJson(a))
      //     .toList(),
    );
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