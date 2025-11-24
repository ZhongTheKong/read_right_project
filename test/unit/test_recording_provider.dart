import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
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
  // test('test_recording_provider_init_audio_permission_granted', () async {
  //     RecordingProvider recordingProvider = RecordingProvider();
  //     when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
  //     await recordingProvider.initAudio();

  //     expect(recordingProvider.recorderReady, true);
  // });

  test('test_recording_provider_init_audio_permission_denied', () async {
      // when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      RecordingProvider recordingProvider = RecordingProvider();
      await recordingProvider.initAudio();

      expect(recordingProvider.recorderReady, true);
  });

  test('test_recording_provider_start_recording_recorder_not_ready', () async {
      // when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      RecordingProvider recordingProvider = RecordingProvider();
      recordingProvider.recorderReady = false;
      await recordingProvider.startRecording('', [], () {});

      expect(recordingProvider.isRecording, false);
      expect(recordingProvider.elapsedMs, 0);
  });
  
  test('test_recording_provider_start_recording_already_recording', () async {
      // when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      RecordingProvider recordingProvider = RecordingProvider();
      recordingProvider.isRecording = true;
      List<Attempt> listOfAttempts = [];
      await recordingProvider.stopRecording('', listOfAttempts, () {});

      expect(listOfAttempts.length, 0);
  });

  test('test_recording_provider_stop_recording_not_recording', () async {
      // when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      RecordingProvider recordingProvider = RecordingProvider();
      recordingProvider.isRecording = false;
      List<Attempt> listOfAttempts = [];
      await recordingProvider.stopRecording('', listOfAttempts, () {});

      expect(listOfAttempts.length, 0);
  });

  test('test_recording_provider_stop_recording_success', () async {
      // when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      RecordingProvider recordingProvider = RecordingProvider();
      recordingProvider.isRecording = false;
      List<Attempt> listOfAttempts = [];
      await recordingProvider.stopRecording('', listOfAttempts, () {});

      expect(listOfAttempts.length, 1);
  });
}

// class MockAudioRecorder extends Mock implements AudioRecorder {}
// class MockAudioPlayer extends Mock implements AudioPlayer {}


// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//   late RecordingProvider provider;
//   late MockAudioRecorder mockRecorder;
//   late MockAudioPlayer mockPlayer;

//   setUp(() {
//     mockRecorder = MockAudioRecorder();
//     mockPlayer = MockAudioPlayer();

//     provider = RecordingProvider();
//     provider
//       ..recorderReady = false
//       ..isRecording = false
//       ..isPlaying = false
//       ..recorder = mockRecorder
//       ..player = mockPlayer;
//   });

//   group('RecordingProvider', () {


//     test('initAudio sets recorderReady when permission granted', () async {
//       RecordingProvider recordingProvider = RecordingProvider();
//       when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
//       await recordingProvider.initAudio();

//       expect(recordingProvider.recorderReady, true);
//     });

//     // test('startRecording throws if permissions missing', () async {
//     //   when(() => mockRecorder.hasPermission()).thenAnswer((_) async => false);

//     //   expect(
//     //     () => provider.startRecording('word', [], null),
//     //     throwsException,
//     //   );
//     // });

//     // test('startRecording sets isRecording and starts timer', () async {
//     //   when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
//     //   when(() => mockRecorder.start(any(), path: any(named: 'path')))
//     //       .thenAnswer((_) async {});
//     //   when(() => mockRecorder.stop()).thenAnswer((_) async => 'fake_path.wav');

//     //   final attempts = <Attempt>[];

//     //   await provider.startRecording('hello', attempts, null);

//     //   expect(provider.isRecording, true);

//     //   // stop recording to clean up timer
//     //   await provider.stopRecording('hello', attempts, null);
//     // });

//     // test('stopRecording inserts attempt into list', () async {
//     //   when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
//     //   when(() => mockRecorder.start(any(), path: any(named: 'path')))
//     //       .thenAnswer((_) async {});
//     //   when(() => mockRecorder.stop()).thenAnswer((_) async => 'fake_path.wav');
//     //   when(() => mockPlayer.setFilePath(any())).thenAnswer((_) async {});
//     //   when(() => mockPlayer.stop()).thenAnswer((_) async {});
//     //   when(() => mockPlayer.duration).thenReturn(Duration(milliseconds: 500));

//     //   final attempts = <Attempt>[];
//     //   await provider.startRecording('test', attempts, null);
//     //   await provider.stopRecording('test', attempts, null);

//     //   expect(provider.isRecording, false);
//     //   expect(attempts.length, 1);
//     //   expect(attempts.first.word, 'test');
//     //   expect(attempts.first.filePath, 'fake_path.wav');
//     // });

//     // test('play sets isPlaying and updates elapsedMs', () async {
//     //   when(() => mockPlayer.setFilePath(any())).thenAnswer((_) async {});
//     //   when(() => mockPlayer.play()).thenAnswer((_) async {});
//     //   when(() => mockPlayer.duration).thenReturn(Duration(milliseconds: 500));
//     //   provider.isPlaying = false;

//     //   await provider.play('fake_path.wav');

//     //   expect(provider.isPlaying, false);
//     // });

//     // test('deleteAudioFile throws if file does not exist', () async {
//     //   expect(
//     //     () => provider.deleteAudioFile('nonexistent.wav'),
//     //     throwsException,
//     //   );
//     // });

//   });
// }
