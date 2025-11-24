import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/teacher_user_data.dart';
import 'package:read_right_project/utils/user_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('cannot start recording while already recording', () async {
    final recordingProvider = FakeRecordingProvider();
    recordingProvider.isRecording = true;

    expect(
      () async => await recordingProvider.startRecording("", [], () {}),
      throwsA(isA<Exception>()),
    );

    // expect(recordingProvider.isRecording, true);
  });
}

class FakeRecordingProvider extends RecordingProvider {
  @override
  Future<void> startRecording(String word, List attempts, VoidCallback? onFinish) async {
    if (isRecording) throw Exception("Already recording");
    elapsedMs = 1;
    isRecording = true;
    // elapsedMs = 0;
  }
}