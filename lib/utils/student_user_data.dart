import 'package:read_right_project/utils/attempt.dart';
import 'package:read_right_project/utils/user_data.dart';

class StudentUserData extends UserData {
  StudentUserData({
    required super.username,
    required super.password,
    required super.isTeacher,
    required this.attempts,
  });
  final List<Attempt> attempts;

  // Deserialize
  factory StudentUserData.fromJson(Map<String, dynamic> json) {
    return StudentUserData(
      username: json['username'],
      password: json['password'],
      isTeacher: json['isTeacher'],
      // attempts: json['attempts'],
      attempts: (json['attempts'] as List<dynamic>)
          .map((a) => Attempt.fromJson(a))
          .toList(),
    );
  }

  // Serialize
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'isTeacher': isTeacher,
      'attempts': attempts.map((a) => a.toJson()).toList(),
    };
  }
}