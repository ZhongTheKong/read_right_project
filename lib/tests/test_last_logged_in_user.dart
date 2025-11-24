import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_right_project/providers/all_users_provider.dart';

void main() {
  test('test_corrupt_allUsersData_teacher_username', () async {
    final provider = AllUsersProvider();
    final path = File('lib/tests/assets/allUsersData_missing_teacher_username_save.json').absolute.path;
    print(path);
    try {
      await provider.loadUserData(path);
      fail('Expected an exception due to missing username');
    } catch (e) {
      // e is the Exception thrown in fromJson
      expect(e.toString(), contains('TeacherUserData | Missing username'));
      // Optional: print the error for debug
      print('Caught error: $e');
    }
  });
}