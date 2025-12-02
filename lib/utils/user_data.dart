class UserData {
  UserData({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.isTeacher,
  });

  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final bool isTeacher;

  // Deserialize
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      isTeacher: json['isTeacher'],
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
    };
  }
}