// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'package:read_right_project/providers/all_users_provider.dart';
// import 'package:read_right_project/providers/session_provider.dart';
// import 'package:read_right_project/providers/recording_provider.dart';
// import 'package:read_right_project/screens/practice_screen.dart';
// import 'package:read_right_project/utils/word.dart';

// // ----- FAKE PROVIDERS -----
// class FakeRecordingProvider extends RecordingProvider {
//   @override
//   bool isAudioRetentionEnabled = true;

//   @override
//   bool isRecording = false;

//   @override
//   int elapsedMs = 0;

//   @override
//   Future<void> initAudio() async {
//     // simulate audio initialization
//     return;
//   }

//   @override
//   Future<void> startRecording(String word, List attempts, VoidCallback? onFinish) async {
//     isRecording = true;
//     notifyListeners();
//   }

//   @override
//   Future<void> stopRecording(String word, List attempts, VoidCallback? onFinish) async {
//     isRecording = false;
//     notifyListeners();
//   }
// }

// class FakeSessionProvider extends SessionProvider {
//   @override
//   List<Word> word_list = [Word(text: 'apple', grade: 'A')];
//   @override
//   int index = 0;

//   @override
//   bool listComplete = false;

//   @override
//   String word_list_name = 'seed_words.csv';

//   @override
//   Future<void> loadWordList(String path) async {
//     return;
//   }

//   @override
//   void nextWord(bool something) {
//     index++;
//   }

//   @override
//   int selectedIndex = 0;
// }

// class FakeAllUsersProvider extends AllUsersProvider {
//   // @override
//   // dynamic allUserData = {
//   //   'lastLoggedInUser': StudentUserData()
//   // };

//   // @override
//   // void saveCurrentUserData() {}
// }

// // ----- WIDGET TESTS -----
// void main() {
//   Widget makeTestableWidget(Widget child) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<RecordingProvider>(
//           create: (_) => FakeRecordingProvider(),
//         ),
//         ChangeNotifierProvider<SessionProvider>(
//           create: (_) => FakeSessionProvider(),
//         ),
//         ChangeNotifierProvider<AllUsersProvider>(
//           create: (_) => FakeAllUsersProvider(),
//         ),
//       ],
//       child: MaterialApp(
//       home: MediaQuery(
//         data: const MediaQueryData(size: Size(800, 1200)), // make test screen bigger
//         child: child,
//       ),
//     ),
//     );
//   }

//   testWidgets('Displays word and grade', (WidgetTester tester) async {
//     await tester.pumpWidget(makeTestableWidget(const PracticeScreen()));
//     await tester.pumpAndSettle();

//     expect(find.text('Word #1\nGrade: A'), findsOneWidget);
//     expect(find.text('apple'), findsOneWidget);
//   });

//   testWidgets('Record button sets isRecording to true', (WidgetTester tester) async {
//     await tester.pumpWidget(makeTestableWidget(const PracticeScreen()));
//     await tester.pumpAndSettle();

//     final recordButton = find.widgetWithIcon(ElevatedButton, Icons.mic);
//     expect(recordButton, findsOneWidget);

//     await tester.tap(recordButton);
//     await tester.pump(); // rebuild after state change

//     final recordingProvider = tester.widget<ChangeNotifierProvider<RecordingProvider>>(find.byType(ChangeNotifierProvider<RecordingProvider>)) as FakeRecordingProvider;
//     expect(recordingProvider.isRecording, true);
//   });

//   testWidgets('Switch toggles audio retention', (WidgetTester tester) async {
//     await tester.pumpWidget(makeTestableWidget(const PracticeScreen()));
//     await tester.pumpAndSettle();

//     final switchFinder = find.byType(Switch);
//     expect(switchFinder, findsOneWidget);

//     await tester.tap(switchFinder);
//     await tester.pump();

//     final recordingProvider = tester.widget<ChangeNotifierProvider<RecordingProvider>>(find.byType(ChangeNotifierProvider<RecordingProvider>)) as FakeRecordingProvider;
//     expect(recordingProvider.isAudioRetentionEnabled, false);
//   });
// }
