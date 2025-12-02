import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/teacher_user_data.dart';
import 'package:read_right_project/utils/user_data.dart';

void main() {
  test('test_allUsersData_lastLoggedInUser_matching_student', () async {
    final provider = AllUsersProvider();
    final path = File('test/unit/assets/allUsersData_lastLoggedInUser_matching_student_save.json').absolute.path;
    print(path);
    await provider.loadUserData(path);
    UserData? lastLoggedInUser = provider.allUserData.lastLoggedInUser;
    expect(lastLoggedInUser, isNotNull);
    expect(lastLoggedInUser, isA<StudentUserData>());
    expect(lastLoggedInUser!.firstName, "John");
    expect(lastLoggedInUser.lastName, "Doe");
    expect(lastLoggedInUser.isTeacher, false);
    expect(lastLoggedInUser.username, "jdoe");
    expect(lastLoggedInUser.password, "1234");
    expect((lastLoggedInUser as StudentUserData).word_list_progression_data, {});

  });
  test('test_allUsersData_lastLoggedInUser_matching_teacher', () async {
    final provider = AllUsersProvider();
    final path = File('test/unit/assets/allUsersData_lastLoggedInUser_matching_teacher_save.json').absolute.path;
    print(path);
    await provider.loadUserData(path);
    UserData? lastLoggedInUser = provider.allUserData.lastLoggedInUser;
    expect(lastLoggedInUser, isNotNull);
    expect(lastLoggedInUser, isA<TeacherUserData>());
    expect(lastLoggedInUser!.firstName, "John");
    expect(lastLoggedInUser.lastName, "Doe");
    expect(lastLoggedInUser.isTeacher, true);
    expect(lastLoggedInUser.username, "jdoe");
    expect(lastLoggedInUser.password, "1234");
    expect((lastLoggedInUser as TeacherUserData).studentUsernames, []);
  });
  test('test_allUsersData_lastLoggedInUser_null_isTeacher', () async {
    final provider = AllUsersProvider();
    final path = File('test/unit/assets/allUsersData_lastLoggedInUser_null_isTeacher_save.json').absolute.path;
    print(path);
    await provider.loadUserData(path);
    UserData? lastLoggedInUser = provider.allUserData.lastLoggedInUser;
    expect(lastLoggedInUser, isNull);
  });
  test('test_allUsersData_lastLoggedInUser_null_isTeacher_username', () async {
    final provider = AllUsersProvider();
    final path = File('test/unit/assets/allUsersData_lastLoggedInUser_null_isTeacher_username_save.json').absolute.path;
    print(path);
    await provider.loadUserData(path);
    UserData? lastLoggedInUser = provider.allUserData.lastLoggedInUser;
    expect(lastLoggedInUser, isNull);
  });
  test('test_allUsersData_lastLoggedInUser_null_username', () async {
    final provider = AllUsersProvider();
    final path = File('test/unit/assets/allUsersData_lastLoggedInUser_null_username_save.json').absolute.path;
    print(path);
    await provider.loadUserData(path);
    UserData? lastLoggedInUser = provider.allUserData.lastLoggedInUser;
    expect(lastLoggedInUser, isNull);
  });
}