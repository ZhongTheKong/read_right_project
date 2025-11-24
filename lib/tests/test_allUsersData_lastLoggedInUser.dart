import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/user_data.dart';

void main() {
  test('test_allUsersData_lastLoggedInUser_matching_student', () async {
    final provider = AllUsersProvider();
    final path = File('lib/tests/assets/allUsersData_lastLoggedInUser_matching_student_save.json').absolute.path;
    print(path);
    await provider.loadUserData(path);
    UserData? lastLoggedInUser = provider.allUserData.lastLoggedInUser;
    expect(lastLoggedInUser, isNotNull);
    expect(lastLoggedInUser, isA<StudentUserData>());
    expect(lastLoggedInUser!.firstName, "John");
    expect(lastLoggedInUser.lastName, "Doe");
    expect(lastLoggedInUser.username, "jdoe");
    expect(lastLoggedInUser.password, "1234");
    expect((lastLoggedInUser as StudentUserData).word_list_attempts, {});
  });
}