import 'package:read_right_project/utils/attempt.dart';
import 'package:read_right_project/utils/user_data.dart';
import 'package:read_right_project/utils/word_list_progression_data.dart';

class StudentUserData extends UserData {
  StudentUserData({
    required super.username,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.isTeacher,
    // required this.attempts,
    // required this.word_list_attempts,
    required this.word_list_progression_data
  });
  // final List<Attempt> attempts;
  // final Map<String, List<Attempt>> word_list_attempts;
  final Map<String, WordListProgressionData> word_list_progression_data;

  // Deserialize
  factory StudentUserData.fromJson(Map<String, dynamic> json) {
    try {
      return StudentUserData(
        username: json['username'] ?? (throw Exception("StudentUserData | Missing username")),
        password: json['password'] ?? (throw Exception("StudentUserData | Missing password")),
        firstName: json['firstName'] ?? (throw Exception("StudentUserData | Missing first name")),
        lastName: json['lastName'] ?? (throw Exception("StudentUserData | Missing last name")),
        isTeacher: json['isTeacher'] ?? false,
        // word_list_attempts: json['word_list_attempts'] != null ? 
        //   (json['word_list_attempts'] as Map<String, dynamic>).map(
        //     (key, value) {
        //       var list = (value as List)
        //           .map((item) => Attempt.fromJson(item))
        //           .toList();
        //       return MapEntry(key, list);
        //     },
        //   )
        //   : (throw Exception("StudentUserData | Missing word list attempts"))
        
        word_list_progression_data: json['word_list_progression_data'] != null ? 
          (json['word_list_progression_data'] as Map<String, dynamic>).map(
            (key, value) {
              // var list = (value as List)
              //     .map((item) => WordListProgressionData.fromJson(item))
              //     .toList();
              return MapEntry(key, WordListProgressionData.fromJson(value));
            },
          )
          : (throw Exception("StudentUserData | Missing word_list_progression_data"))

        // username: json['username'] ?? "",
        // password: json['password'] ?? "",
        // firstName: json['firstName'] ?? "",
        // lastName: json['lastName'] ?? "",
        // isTeacher: json['isTeacher'] ?? false,
        // word_list_attempts: json['word_list_attempts'] != null ? 
        //   (json['word_list_attempts'] as Map<String, dynamic>).map(
        //     (key, value) {
        //       var list = (value as List)
        //           .map((item) => Attempt.fromJson(item))
        //           .toList();
        //       return MapEntry(key, list);
        //     },
        //   )
        //   : {}

        // word_list_attempts: (json['word_list_attempts'] as Map<String, dynamic>).map(
        //   (key, value) {
        //     var list = (value as List)
        //         .map((item) => Attempt.fromJson(item))
        //         .toList();
        //     return MapEntry(key, list);
        //   },
        // )
      );
    }
      // attempts: json['attempts'],
      // attempts: (json['attempts'] as List<dynamic>)
      //     .map((a) => Attempt.fromJson(a))
      //     .toList(),
    on FormatException catch (e) {
      // Happens when JSON is malformed
      print("StudentUserData.fromJSON | JSON format error: $e");

      // Optionally: rename the bad file so user doesn't get stuck
      throw Exception("Saved data file (StudentUserData) is corrupted. ($e)");
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
      // 'attempts': attempts.map((a) => a.toJson()).toList(),
      // 'word_list_attempts': word_list_attempts.map((key, value) {
      //   return MapEntry(key, value.map((e) => e.toJson()).toList());
      // }),
      'word_list_progression_data': word_list_progression_data.map((key, value) {
        // return MapEntry(key, value.map((e) => e.toJson()).toList());
        return MapEntry(key, value.toJson());

      }),
    };
  }
}