import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/speech_service.dart';

final SpeechService azureService = SpeechService(
  key: dotenv.env['AZURE_SPEECH_KEY']!,
  region: dotenv.env['AZURE_SPEECH_REGION']!,
);

// Optional: cache results locally to avoid repeated calls
// final Map<String, String> _azureResultsCache = {};

Future<double> getAzureResult(String wavPath, String referenceText) async {
  // if (_azureResultsCache.containsKey(wavPath)) {
  //   return _azureResultsCache[wavPath]!;
  // }

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
      // _azureResultsCache[wavPath] = formattedResult;
      return pronunciationScore;
    }
  } catch (e) {
    print("Azure assessment error: $e");
  }
  return 0.0;

  // return "No result";
}