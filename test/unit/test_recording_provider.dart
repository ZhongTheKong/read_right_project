import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:read_right_project/providers/recording_provider.dart';

import 'package:read_right_project/utils/attempt.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAudioRecorder mockRecorder;
  late MockAudioPlayer mockPlayer;
  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');

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
}