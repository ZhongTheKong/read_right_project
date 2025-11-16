import 'package:read_right_project/utils/user_data.dart';

class AllUserData {
  AllUserData({
    required this.lastLoggedInUser,
    required this.userDataList,
  });
  UserData? lastLoggedInUser;
  final List<UserData> userDataList;

    // Deserialize
  factory AllUserData.fromJson(Map<String, dynamic> json) {
    return AllUserData(
      lastLoggedInUser: UserData.fromJson(json['lastLoggedInUser']),
      // attempts: json['attempts'],
      userDataList: (json['userDataList'] as List<dynamic>)
          .map((a) => UserData.fromJson(a))
          .toList(),
    );
  }

  // Serialize
  Map<String, dynamic> toJson() {
    return {
      'lastLoggedInUser': lastLoggedInUser?.toJson(),
      'userDataList': userDataList.map((a) => a.toJson()).toList(),
    };
  }
}