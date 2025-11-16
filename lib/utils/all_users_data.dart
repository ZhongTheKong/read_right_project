// import 'package:read_right_project/utils/user_data.dart';

// class AllUsersData {
//   AllUsersData({
//     required this.allUserData,
//   });
//   final List<UserData> allUserData;

//     // Deserialize
//   factory AllUsersData.fromJson(Map<String, dynamic> json) {
//     return AllUsersData(
//       username: json['username'],
//       password: json['password'],
//       isTeacher: json['isTeacher'],
//       // attempts: json['attempts'],
//       allUserData: (json['allUserData'] as List<dynamic>)
//           .map((a) => Attempt.fromJson(a))
//           .toList(),
//     );
//   }

//   // Serialize
//   Map<String, dynamic> toJson() {
//     return {
//       'username': username,
//       'password': password,
//       'isTeacher': isTeacher,
//       'attempts': attempts,
//     };
//   }
// }