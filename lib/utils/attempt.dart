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
}