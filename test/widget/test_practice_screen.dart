import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/screens/practice_screen.dart';
import 'package:read_right_project/utils/all_users_data.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/word.dart';

// Mock classes
class MockRecordingProvider extends Mock implements RecordingProvider {}
class MockSessionProvider extends Mock implements SessionProvider {}
class MockAllUsersProvider extends Mock implements AllUsersProvider {}

// flutter test test/widget/test_practice_screen.dart

void main() {
  late MockRecordingProvider mockRecordingProvider;
  late MockSessionProvider mockSessionProvider;
  late MockAllUsersProvider mockAllUsersProvider;

  setUp(() {
    mockRecordingProvider = MockRecordingProvider();
    mockSessionProvider = MockSessionProvider();
    mockAllUsersProvider = MockAllUsersProvider();

    // Default stubs
    when(() => mockRecordingProvider.initAudio()).thenAnswer((_) async {});
    when(() => mockRecordingProvider.startRecording(any(), any(), any())).thenAnswer(
      (_) async { 
        await Future.delayed(const Duration(seconds: 1));
      }
    );
    when(() => mockRecordingProvider.stopRecording(any(), any(), any())).thenAnswer(
      (_) async { 
        await Future.delayed(const Duration(seconds: 1));
      }
    );
    when(() => mockRecordingProvider.isAudioRetentionEnabled).thenReturn(true);
    when(() => mockRecordingProvider.elapsedMs).thenReturn(0);

    when(() => mockSessionProvider.word_list).thenReturn([
      // Minimal dummy Word object
      Word(grade: 'Great', text: "Bob")
    ]);
    when(() => mockSessionProvider.index).thenReturn(0);
    when(() => mockSessionProvider.word_list_name).thenReturn("Test List");
    when(() => mockSessionProvider.listComplete).thenReturn(false);

    when(() => mockAllUsersProvider.allUserData).thenReturn(
      AllUserData(
        lastLoggedInUserIsTeacher: null, 
        lastLoggedInUserUsername: null, 
        studentUserDataList: [StudentUserData(firstName: '', lastName: '', username: '', password: '', isTeacher: false, word_list_progression_data: {})],

        teacherUserDataList: []
      )
    );

    when(() => mockSessionProvider.loadWordList(any()))
      .thenAnswer(
        (_) async { 
          await Future.delayed(const Duration(seconds: 1));
        }
      ); // returns a Future<void>
  });

  testWidgets('Record button triggers startRecording', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<RecordingProvider>.value(value: mockRecordingProvider),
          ChangeNotifierProvider<SessionProvider>.value(value: mockSessionProvider),
          ChangeNotifierProvider<AllUsersProvider>.value(value: mockAllUsersProvider),
        ],
        child: MaterialApp(home: PracticeScreen()),
      ),
    );

    // Wait for FutureBuilders to complete
    await tester.pumpAndSettle();
    final recordButton = find.widgetWithText(ElevatedButton, 'Record');
    expect(recordButton, findsOneWidget);

    await tester.tap(recordButton);
    await tester.pump();

    verify(() => mockRecordingProvider.startRecording(any(), any(), any())).called(1);
  });
}
