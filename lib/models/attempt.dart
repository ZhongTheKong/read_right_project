import 'package:uuid/uuid.dart';

class Attempt {
  final int? id;            // Local DB ID
  final String uuid;        // Stable logical ID
  final String studentId;
  final String data;        // JSON or text payload
  final DateTime updatedAt; // Last modified time
  final bool dirty;         // Needs sync?

  Attempt({
    this.id,
    required this.uuid,
    required this.studentId,
    required this.data,
    required this.updatedAt,
    required this.dirty,
  });

  factory Attempt.createNew({
    required String studentId,
    required String data,
  }) {
    return Attempt(
      id: null,
      uuid: const Uuid().v4(),
      studentId: studentId,
      data: data,
      updatedAt: DateTime.now(),
      dirty: true,
    );
  }

  Attempt copyWith({
    int? id,
    String? uuid,
    String? studentId,
    String? data,
    DateTime? updatedAt,
    bool? dirty,
  }) {
    return Attempt(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      studentId: studentId ?? this.studentId,
      data: data ?? this.data,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
    );
  }

  factory Attempt.fromMap(Map<String, dynamic> map) {
    return Attempt(
      id: map['id'] as int?,
      uuid: map['uuid'] as String,
      studentId: map['studentId'] as String,
      data: map['data'] as String,
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      dirty: map['dirty'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'studentId': studentId,
      'data': data,
      'updatedAt': updatedAt.toIso8601String(),
      'dirty': dirty ? 1 : 0,
    };
  }
}
