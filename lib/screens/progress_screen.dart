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
        // student?.word_list_attempts[sessionProvider.word_list_name] ?? [];
        student?.word_list_progression_data[sessionProvider.word_list_name]?.attempts ?? [];


    int numberOfAttempts = attempts.length;
    double highestScore = 0.0;
    double averageScore = 0.0;
    String mostMissedWord = 'N/A';

    if (attempts.isNotEmpty) {
      // Calculate Highest Score
      highestScore = attempts.map((a) => a.score).reduce((a, b) => a > b ? a : b);
      averageScore = attempts.fold(0.0, (sum, item) => sum + item.score) / attempts.length;
      final missedWords = attempts
          .where((attempt) => attempt.score < 70)
          .map((attempt) => attempt.word)
          .toList();

      if (missedWords.isNotEmpty) {
        final wordCounts = <String, int>{};
        for (var word in missedWords) {
          wordCounts[word] = (wordCounts[word] ?? 0) + 1;
        }
        mostMissedWord = wordCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Progress Summary')),
      body: Column(
        children: [
          // --- 3. Display Statistics in a Summary Card ---
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Hi, ${student?.firstName ?? "Student"}!',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatColumn('Attempts', '$numberOfAttempts'),
                        _buildStatColumn('Highest Score', '${(highestScore).toStringAsFixed(0)}%'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatColumn('Most Missed Word:', mostMissedWord),
                        _buildStatColumn('Average Score', '${averageScore.toStringAsFixed(0)}%'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(thickness: 1),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Attempt History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          // --- 4. Display List of Attempts ---
          Expanded(
            child: attempts.isEmpty
                ? const Center(child: Text('No attempts yet. Time to practice!'))
                : ListView.builder(
              itemCount: attempts.length,
              itemBuilder: (context, i) {
                final iterAttempt = attempts[i];
                final exists = File(iterAttempt.filePath).existsSync();

                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${(iterAttempt.score).toStringAsFixed(0)}'),
                    backgroundColor: iterAttempt.score > 70 ? Colors.green : Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  title: Text(iterAttempt.word, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Duration: ~${(iterAttempt.durationMs / 1000).toStringAsFixed(1)}s',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    tooltip: 'Play Recording',
                    onPressed: (!exists || recordingProvider.isPlaying)
                        ? null // Disable button if file doesn't exist or already playing
                        : () => recordingProvider.play(iterAttempt.filePath),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for displaying a statistic
  Widget _buildStatColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}