import 'package:read_right_project/utils/attempt.dart';

class WordListProgressionData {
  WordListProgressionData({
    required this.wordListName,
    required this.wordListPath,
    required this.currIndex,
    required this.attempts
  });

  final String wordListName;
  final String wordListPath;
  int currIndex = 0;
  final List<Attempt> attempts;

  // bool isWordListComplete() {
  //   return currIndex == 
  // }

  factory WordListProgressionData.fromJson(Map<String, dynamic> json) {
    try {
      return WordListProgressionData(
        wordListName: json['wordListName'] ?? (throw Exception("WordListProgressionData | Missing wordListName")),
        wordListPath: json['wordListPath'] ?? (throw Exception("WordListProgressionData | Missing wordListPath")),
        currIndex: json['currIndex'] ?? (throw Exception("WordListProgressionData | Missing currIndex")),
        attempts: json['attempts'] != null ? 
          (json['attempts'] as List)
              .map((item) => Attempt.fromJson(item))
              .toList()
          : (throw Exception("WordListProgressionData | Missing attempts"))
      );
    }
    on FormatException catch (e) {
      // Happens when JSON is malformed
      print("WordListProgressionData.fromJSON | JSON format error: $e");

      // Optionally: rename the bad file so user doesn't get stuck
      throw Exception("Saved data file (WordListProgressionData) is corrupted. ($e)");
    }
  }

  // Serialize
  Map<String, dynamic> toJson() {
    return {
      'wordListName': wordListName,
      'wordListPath': wordListPath,
      'currIndex': currIndex,
      // 'attempts': attempts.map((a) => a.toJson()).toList(),
      'attempts': attempts.map((e) => e.toJson()).toList(),
    };
  }
}