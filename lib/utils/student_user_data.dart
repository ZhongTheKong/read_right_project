import 'package:read_right_project/utils/attempt.dart';
import 'package:read_right_project/utils/user_data.dart';

class StudentUserData extends UserData {
  StudentUserData({
    required super.username,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.isTeacher,
    // required this.attempts,
    required this.word_list_attempts,
  });
  // final List<Attempt> attempts;
  final Map<String, List<Attempt>> word_list_attempts;

  // Deserialize
  factory StudentUserData.fromJson(Map<String, dynamic> json) {
    return StudentUserData(
      username: json['username'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      isTeacher: json['isTeacher'],
      word_list_attempts: (json['word_list_attempts'] as Map<String, dynamic>).map(
      (key, value) {
        var list = (value as List)
            .map((item) => Attempt.fromJson(item))
            .toList();
        return MapEntry(key, list);
      },
    ),
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
      // 'attempts': attempts.map((a) => a.toJson()).toList(),
      'word_list_attempts': word_list_attempts.map((key, value) {
        return MapEntry(key, value.map((e) => e.toJson()).toList());
      }),
    };
  }
}