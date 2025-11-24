import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/speech_service.dart';

class PronunciationScreen extends StatefulWidget {
  @override
  _PronunciationScreenState createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> {
  final SpeechService service = SpeechService(
    key: dotenv.env['AZURE_SPEECH_KEY']!,
    region: dotenv.env['AZURE_SPEECH_REGION']!,
  );

  String result = "";
  String referenceText = "Hello world";

  Future<void> runTest() async {
    try {
      // Load WAV from assets
      final byteData = await rootBundle.load('assets/test.wav');
      final bytes = byteData.buffer.asUint8List();

      // Create temp file
      final tempDir = Directory.systemTemp;
      final tempPath = '${tempDir.path}/temp_test.wav';
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(bytes);

      // Send to Azure
      final resultObj = await service.assessPronunciation(
        tempFile,
        referenceText,
      );

      String formattedResult = "";

      if (resultObj != null &&
          resultObj['RecognitionStatus'] == 'Success' &&
          resultObj['NBest'] != null &&
          resultObj['NBest'].isNotEmpty) {
        final nbest = resultObj['NBest'][0];

        formattedResult =
            """
Reference Text: ${resultObj['DisplayText'] ?? referenceText}

Overall Scores:
  Accuracy: ${nbest['AccuracyScore']}
  Fluency: ${nbest['FluencyScore']}
  Completeness: ${nbest['CompletenessScore']}
  Pronunciation: ${nbest['PronScore']}
""";

        if (nbest['Words'] != null && nbest['Words'].isNotEmpty) {
          formattedResult += "\nWord-level Scores:\n";
          for (var word in nbest['Words']) {
            formattedResult +=
                "  ${word['Word']}: Accuracy ${word['AccuracyScore']}, ErrorType ${word['ErrorType']}\n";
          }
        }
      } else {
        formattedResult = "No valid pronunciation assessment returned.";
      }

      setState(() {
        result = formattedResult;
      });
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pronunciation Assessment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Reference sentence",
              ),
              onChanged: (val) => referenceText = val,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: runTest,
              child: const Text("Send to Azure"),
            ),
            const SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: Text(result))),
          ],
        ),
      ),
    );
  }
}
