import 'package:read_right_project/utils/user_data.dart';
import 'package:read_right_project/utils/word_list_progression_data.dart';

/// -------------------------------------------------------------
/// StudentUserData
///
/// Represents a student user, extending from UserData.
///
/// PRE:
///   • Requires all UserData fields: username, password, firstName, lastName, isTeacher
///   • word_list_progression_data must be provided (map of word list name to WordListProgressionData)
///
/// POST:
///   • Provides serialization (toJson) and deserialization (fromJson)
///   • Handles missing or malformed JSON fields with exceptions
/// -------------------------------------------------------------
class StudentUserData extends UserData {
  StudentUserData({
    required super.username,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.isTeacher,
    required this.word_list_progression_data
  });

  final Map<String, WordListProgressionData> word_list_progression_data;

  /// -------------------------------------------------------------
  /// fromJson
  ///
  /// Deserializes a JSON map into a StudentUserData object.
  /// Throws an exception if required fields are missing or JSON is malformed.
  /// -------------------------------------------------------------
  factory StudentUserData.fromJson(Map<String, dynamic> json) {
    try {
      return StudentUserData(
        username: json['username'] ?? (throw Exception("StudentUserData | Missing username")),
        password: json['password'] ?? (throw Exception("StudentUserData | Missing password")),
        firstName: json['firstName'] ?? (throw Exception("StudentUserData | Missing first name")),
        lastName: json['lastName'] ?? (throw Exception("StudentUserData | Missing last name")),
        isTeacher: json['isTeacher'] ?? false,
        word_list_progression_data: json['word_list_progression_data'] != null ? 
          (json['word_list_progression_data'] as Map<String, dynamic>).map(
            (key, value) {
              return MapEntry(key, WordListProgressionData.fromJson(value));
            },
          )
          : (throw Exception("StudentUserData | Missing word_list_progression_data"))
      );
    } 
    on FormatException catch (e) {
      // Happens when JSON is malformed
      print("StudentUserData.fromJSON | JSON format error: $e");
      throw Exception("Saved data file (StudentUserData) is corrupted. ($e)");
    }
  }

  /// -------------------------------------------------------------
  /// toJson
  ///
  /// Serializes the StudentUserData object to a JSON map.
  /// -------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'isTeacher': isTeacher,
      'word_list_progression_data': word_list_progression_data.map((key, value) {
        return MapEntry(key, value.toJson());
      }),
    };
  }
}
