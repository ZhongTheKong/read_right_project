import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import '../providers/session_provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/utils/attempt.dart';
// Somewhere at the top of your file
import '../utils/speech_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}


class _ProgressScreenState extends State<ProgressScreen> {
  // final SpeechService azureService = SpeechService(
  //   key: dotenv.env['AZURE_SPEECH_KEY']!,
  //   region: dotenv.env['AZURE_SPEECH_REGION']!,
  // );

  // // Optional: cache results locally to avoid repeated calls
  // final Map<String, String> _azureResultsCache = {};

  // Future<String> getAzureResult(String wavPath, String referenceText) async {
  //   if (_azureResultsCache.containsKey(wavPath)) {
  //     return _azureResultsCache[wavPath]!;
  //   }

  //   try {
  //     final resultObj = await azureService.assessPronunciation(
  //       File(wavPath),
  //       referenceText,
  //     );

  //     if (resultObj != null &&
  //         resultObj['RecognitionStatus'] == 'Success' &&
  //         resultObj['NBest'] != null &&
  //         resultObj['NBest'].isNotEmpty) {
  //       final nbest = resultObj['NBest'][0];

  //       String formattedResult =
  //           "Accuracy: ${nbest['AccuracyScore']}, Pronunciation: ${nbest['PronScore']}";
  //       _azureResultsCache[wavPath] = formattedResult;
  //       return formattedResult;
  //     }
  //   } catch (e) {
  //     print("Azure assessment error: $e");
  //   }

  //   return "No result";
  // }

  @override
  Widget build(BuildContext context) {
    RecordingProvider recordingProvider = context.watch<RecordingProvider>();
    AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();
    SessionProvider sessionProvider = context.watch<SessionProvider>();

    final currentUser = allUsersProvider.allUserData.lastLoggedInUser;
    final StudentUserData? student = currentUser is StudentUserData ? currentUser : null;

    final List<Attempt> attempts =
        student?.word_list_attempts[sessionProvider.word_list_name] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Progress Screen')),
      body: attempts.isEmpty
          ? const Center(child: Text('No attempts yet'))
          : ListView.builder(
              itemCount: attempts.length,
              itemBuilder: (context, i) {
                final iterAttempt = attempts[i];
                final exists = File(iterAttempt.filePath).existsSync();

                return ListTile(
                  title: Text(iterAttempt.word),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attempt ${ (student?.word_list_attempts[sessionProvider.word_list_name]?.length ?? 0) - i}, Duration: ~${(iterAttempt.durationMs / 1000).toStringAsFixed(1)}s',
                      ),
                      Text("Azure: ${iterAttempt.score}"),
                      // Display Azure results
                      // FutureBuilder<String>(
                      //   future: getAzureResult(iterAttempt.filePath, iterAttempt.word),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return const Text("Loading Azure result...");
                      //     } else if (snapshot.hasError) {
                      //       return Text("Error: ${snapshot.error}");
                      //     } else {
                      //       return Text("Azure: ${snapshot.data}");
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: (!exists || recordingProvider.isPlaying)
                            ? null
                            : () => recordingProvider.play(iterAttempt.filePath),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
