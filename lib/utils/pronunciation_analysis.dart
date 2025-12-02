import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/speech_service.dart';

/// -------------------------------------------------------------
/// azureService
///
/// Global instance of SpeechService configured with Azure keys.
/// -------------------------------------------------------------
final SpeechService azureService = SpeechService(
  key: dotenv.env['AZURE_SPEECH_KEY']!,
  region: dotenv.env['AZURE_SPEECH_REGION']!,
);

/// -------------------------------------------------------------
/// getAzureResult
///
/// Calls Azure Speech Service to assess pronunciation of a word/phrase
/// from a local WAV file.
///
/// PRE:
///   • wavPath: path to the recorded audio file
///   • referenceText: the reference text to compare pronunciation against
///
/// POST:
///   • Returns a double score representing pronunciation (0.0 to 100.0)
///   • Returns 0.0 if assessment fails
/// -------------------------------------------------------------
Future<double> getAzureResult(String wavPath, String referenceText) async {
  try {
    final resultObj = await azureService.assessPronunciation(
      File(wavPath),
      referenceText,
    );

    if (resultObj['RecognitionStatus'] == 'Success' &&
        resultObj['NBest'] != null &&
        resultObj['NBest'].isNotEmpty) {
      final nbest = resultObj['NBest'][0];

      double pronunciationScore = nbest['PronScore'];
      return pronunciationScore;
    }
  } catch (e) {
    print("Azure assessment error: $e");
  }
  return 0.0;
}
