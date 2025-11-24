import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SpeechService {
  final String key;
  final String region;

  SpeechService({
    required this.key,
    required this.region,
  });

  Future<Map<String, dynamic>> assessPronunciation(
      File wavFile, String referenceText) async {

    final configJson = {
      "referenceText": referenceText,
      "gradingSystem": "HundredMark",
      "dimension": "Comprehensive",
      "phonemeAlphabet": "IPA"
    };

    final configBase64 = base64.encode(utf8.encode(json.encode(configJson)));

    final url = Uri.parse(
      "https://$region.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US",
    );

    final audioBytes = await wavFile.readAsBytes();

    final response = await http.post(
      url,
      headers: {
        "Ocp-Apim-Subscription-Key": key,
        "Content-Type": "audio/wav",
        "Pronunciation-Assessment": configBase64,
      },
      body: audioBytes,
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Azure Speech error: ${response.statusCode}\n${response.body}");
    }

    return json.decode(response.body);
  }
}
