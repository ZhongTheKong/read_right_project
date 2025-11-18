import 'package:read_right_project/utils/attempt.dart';

class UserData {
  UserData({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.isTeacher,
    //required this.attempts,
  });

  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final bool isTeacher;
  //final List<Attempt> attempts;

  // Deserialize
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      isTeacher: json['isTeacher'],
      // attempts: json['attempts'],
      //attempts: (json['attempts'] as List<dynamic>)
      //    .map((a) => Attempt.fromJson(a))
      //    .toList(),
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
      //'attempts': attempts,
    };
  }
}