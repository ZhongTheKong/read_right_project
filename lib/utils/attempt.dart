class Attempt {
  Attempt({
    required this.word,
    required this.score,
    required this.filePath,
    required this.durationMs,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String word;
  final double score;
  final String filePath;
  final int durationMs;
  final DateTime createdAt;

  // Deserialize
  factory Attempt.fromJson(Map<String, dynamic> json) {
    return Attempt(
      word: json['word'],
      score: json['score'],
      filePath: json['filePath'],
      durationMs: json['durationMs'],
      // createdAt: json['createdAt'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Serialize
  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'score': score,
      'filePath': filePath,
      'durationMs': durationMs,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}