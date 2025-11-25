import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/teacher_user_data.dart';
import 'package:read_right_project/utils/user_data.dart';

import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:read_right_project/utils/attempt.dart';
import 'dart:async';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // test('test_recording_provider_init_audio_permission_granted', () async {
  //     RecordingProvider recordingProvider = RecordingProvider();
  //     when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
  //     await recordingProvider.initAudio();

  //     expect(recordingProvider.recorderReady, true);
  // });
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAudioRecorder mockRecorder;
  late MockAudioPlayer mockPlayer;
  // late RecordingProvider recordingProvider;
  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');

  // setUp(() {    
  //   channel.setMockMethodCallHandler((MethodCall methodCall) async {
  //     if (methodCall.method == 'getApplicationDocumentsDirectory') {
  //       return '/mock/path'; // fake directory path
  //     }
  //     return null;
  //   });
  // });

  // tearDown(() {
  //   channel.setMockMethodCallHandler(null);
  // });

  setUp(() {
    mockRecorder = MockAudioRecorder();
    mockPlayer = MockAudioPlayer();
    // Use the defaultBinaryMessenger for mocking platform calls
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '/mock/path'; // fake path for tests
      }
      return null;
    });
  });

  tearDown(() {
    // Remove the mock after the test
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

test('test_recording_provider_init_audio_permission_denied', () async {
  // Simulate denied permission
  when(() => mockRecorder.hasPermission()).thenAnswer((_) async => false);
  // Create the provider with the mocked recorder
  RecordingProvider recordingProvider = RecordingProvider(
    recorder: mockRecorder, 
    player: mockPlayer,
  );
  // Initialize audio
  await recordingProvider.initAudio();
  // Expect recorderReady to be false since permission is denied
  expect(recordingProvider.recorderReady, false);
});

  test('initAudio sets recorderReady when permission granted', () async {
    RecordingProvider recordingProvider = RecordingProvider(recorder: mockRecorder, player: mockPlayer);

    when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);

    await recordingProvider.initAudio();

    expect(recordingProvider.recorderReady, true);
    verify(() => mockRecorder.hasPermission()).called(1);
  });

  test('test_recording_provider_start_recording_recorder_not_ready', () async {
      when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      RecordingProvider recordingProvider = RecordingProvider(recorder: mockRecorder, player: mockPlayer);
      recordingProvider.recorderReady = false;
      await recordingProvider.startRecording('', [], () {});

      expect(recordingProvider.isRecording, false);
      expect(recordingProvider.elapsedMs, 0);
  });
  
  test('test_recording_provider_start_recording_already_recording', () async {
      when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      RecordingProvider recordingProvider = RecordingProvider(recorder: mockRecorder, player: mockPlayer);
      recordingProvider.isRecording = true;
      List<Attempt> listOfAttempts = [];
      await recordingProvider.stopRecording('', listOfAttempts, () {});

      expect(listOfAttempts.length, 0);
  });

  test('test_recording_provider_stop_recording_not_recording', () async {
      when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      RecordingProvider recordingProvider = RecordingProvider(recorder: mockRecorder, player: mockPlayer);
      recordingProvider.isRecording = false;
      List<Attempt> listOfAttempts = [];
      await recordingProvider.stopRecording('', listOfAttempts, () {});

      expect(listOfAttempts.length, 0);
  });

  // test('test_recording_provider_stop_recording_success', () async {
  //     when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
  //     RecordingProvider recordingProvider = RecordingProvider(recorder: mockRecorder, player: mockPlayer);
  //     recordingProvider.initAudio();
  //     recordingProvider.isRecording = true;
  //     List<Attempt> listOfAttempts = [];
  //     await recordingProvider.startRecording('', listOfAttempts, () {});
  //     await Future.delayed(Duration(seconds: 1));
  //     await recordingProvider.stopRecording('', listOfAttempts, () {});

  //     expect(listOfAttempts.length, 1);
  // });
}