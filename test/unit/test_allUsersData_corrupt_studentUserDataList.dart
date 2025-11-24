import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_right_project/providers/all_users_provider.dart';

void main() {
  test('test_allUsersData_corrupt_studentUserDataList_username', () async {
    final provider = AllUsersProvider();
    final path = File('test/unit/assets/allUsersData_studentUserDataList_missing_username_save.json').absolute.path;
    print(path);
    try {
      await provider.loadUserData(path);
      fail('Expected an exception due to missing username');
    } catch (e) {
      // e is the Exception thrown in fromJson
      expect(e.toString(), contains('StudentUserData | Missing username'));
      // Optional: print the error for debug
      print('Caught error: $e');
    }
  });
  test('test_allUsersData_corrupt_studentUserDataList_password', () async {
    final provider = AllUsersProvider();
    final path = File('test/unit/assets/allUsersData_studentUserDataList_missing_password_save.json').absolute.path;
    try {
      await provider.loadUserData(path);
      fail('Expected an exception due to missing password');
    } catch (e) {
      // e is the Exception thrown in fromJson
      expect(e.toString(), contains('StudentUserData | Missing password'));
      // Optional: print the error for debug
      print('Caught error: $e');
    }
  });
  test('test_allUsersData_corrupt_studentUserDataList_first_name', () async {
    final provider = AllUsersProvider();
    final path = File('test/unit/assets/allUsersData_studentUserDataList_missing_first_name_save.json').absolute.path;
    try {
      await provider.loadUserData(path);
      fail('Expected an exception due to missing first name');
    } catch (e) {
      // e is the Exception thrown in fromJson
      expect(e.toString(), contains('StudentUserData | Missing first name'));
      // Optional: print the error for debug
      print('Caught error: $e');
    }
  });
  test('test_allUsersData_corrupt_studentUserDataList_last_name', () async {
    final provider = AllUsersProvider();
    final path = File('test/unit/assets/allUsersData_studentUserDataList_missing_last_name_save.json').absolute.path;
    try {
      await provider.loadUserData(path);
      fail('Expected an exception due to missing last name');
    } catch (e) {
      // e is the Exception thrown in fromJson
      expect(e.toString(), contains('StudentUserData | Missing last name'));
      // Optional: print the error for debug
      print('Caught error: $e');
    }
  });
}
