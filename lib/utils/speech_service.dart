import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// -------------------------------------------------------------
// SpeechService
//
// PRE:
//   • Requires a valid Azure Speech subscription key and region
//   • Wav file must exist and be readable
//   • referenceText must be a non-empty string
//
// Provides functionality to assess pronunciation using Azure's
// Pronunciation Assessment API.
//
// POST:
//   • Returns a Map<String, dynamic> containing the assessment result
//   • Throws Exception if the HTTP request fails or Azure returns an error
// -------------------------------------------------------------
class SpeechService {
  final String key;      // Azure subscription key
  final String region;   // Azure region, e.g., "eastus"

  SpeechService({
    required this.key,
    required this.region,
  });

  // -------------------------------------------------------------
  // assessPronunciation
  //
  // PRE:
  //   • wavFile exists and is a valid audio/wav file
  //   • referenceText is provided for pronunciation assessment
  //
  // POST:
  //   • Returns a Map<String, dynamic> representing the assessment
  //   • Throws an Exception if the HTTP request fails or response is not 200
  // -------------------------------------------------------------
  Future<Map<String, dynamic>> assessPronunciation(
      File wavFile, String referenceText) async {

    // Configuration for Azure Pronunciation Assessment
    final configJson = {
      "referenceText": referenceText,
      "gradingSystem": "HundredMark",
      "dimension": "Comprehensive",
      "phonemeAlphabet": "IPA"
    };

    // Encode configuration as Base64 for HTTP header
    final configBase64 = base64.encode(utf8.encode(json.encode(configJson)));

    // Azure Speech API endpoint
    final url = Uri.parse(
      "https://$region.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US",
    );

    // Read audio file bytes
    final audioBytes = await wavFile.readAsBytes();

    // POST request to Azure Speech service
    final response = await http.post(
      url,
      headers: {
        "Ocp-Apim-Subscription-Key": key,
        "Content-Type": "audio/wav",
        "Pronunciation-Assessment": configBase64,
      },
      body: audioBytes,
    );

    // Error handling
    if (response.statusCode != 200) {
      throw Exception(
        "Azure Speech error: ${response.statusCode}\n${response.body}"
      );
    }

    // Return decoded JSON response
    return json.decode(response.body);
  }
}
