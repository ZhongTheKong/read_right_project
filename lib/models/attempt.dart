import 'package:uuid/uuid.dart';

class Attempt {
  final int? id;               // local auto-increment
  final String uuid;           // logical ID
  final String studentId;
  final String classId;
  final String audioUrl;       // or "" until uploaded
  final String transcript;     // speech-to-text result
  final DateTime updatedAt;    // last edit time
  final bool dirty;            // needs sync?

  Attempt({
    this.id,
    required this.uuid,
    required this.studentId,
    required this.classId,
    required this.audioUrl,
    required this.transcript,
    required this.updatedAt,
    this.dirty = true,
  });

  /// Create a new Attempt with a UUID
  factory Attempt.newAttempt({
    required String studentId,
    required String classId,
    required String audioUrl,
    required String transcript,
  }) {
    return Attempt(
      uuid: const Uuid().v4(),
      studentId: studentId,
      classId: classId,
      audioUrl: audioUrl,
      transcript: transcript,
      updatedAt: DateTime.now(),
    );
  }

  Attempt copyWith({
    int? id,
    String? uuid,
    String? studentId,
    String? classId,
    String? audioUrl,
    String? transcript,
    DateTime? updatedAt,
    bool? dirty,
  }) {
    return Attempt(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      audioUrl: audioUrl ?? this.audioUrl,
      transcript: transcript ?? this.transcript,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'uuid': uuid,
        'studentId': studentId,
        'classId': classId,
        'audioUrl': audioUrl,
        'transcript': transcript,
        'updatedAt': updatedAt.toIso8601String(),
        'dirty': dirty ? 1 : 0,
      };

  factory Attempt.fromMap(Map<String, dynamic> map) {
    return Attempt(
      id: map['id'] as int?,
      uuid: map['uuid'],
      studentId: map['studentId'],
      classId: map['classId'],
      audioUrl: map['audioUrl'],
      transcript: map['transcript'],
      updatedAt: DateTime.parse(map['updatedAt']),
      dirty: map['dirty'] == 1,
    );
  }
}
