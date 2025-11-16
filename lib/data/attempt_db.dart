import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../models/attempt.dart';

class AttemptsDb {
  static final AttemptsDb _instance = AttemptsDb._internal();
  factory AttemptsDb() => _instance;
  AttemptsDb._internal();

  static const _dbName = 'attempts_offline.db';
  static const table = 'attempts';
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE $table(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uuid TEXT NOT NULL UNIQUE,
            studentId TEXT NOT NULL,
            classId TEXT NOT NULL,
            audioUrl TEXT NOT NULL,
            transcript TEXT NOT NULL,
            updatedAt TEXT NOT NULL,
            dirty INTEGER NOT NULL DEFAULT 1
          )
        ''');
      },
    );
    return _db!;
  }

  Future<List<Attempt>> getAll() async {
    final db = await database;
    final rows = await db.query(table, orderBy: 'updatedAt DESC');
    return rows.map(Attempt.fromMap).toList();
  }

  Future<Attempt> upsert(Attempt a) async {
    final db = await database;
    final map = a.toMap()..remove('id');

    final existing = await db.query(
      table,
      where: 'uuid = ?',
      whereArgs: [a.uuid],
      limit: 1,
    );

    if (existing.isEmpty) {
      final id = await db.insert(
        table,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return a.copyWith(id: id);
    } else {
      await db.update(table, map, where: 'uuid = ?', whereArgs: [a.uuid]);
      final row = await db.query(
        table,
        where: 'uuid = ?',
        whereArgs: [a.uuid],
        limit: 1,
      );
      return Attempt.fromMap(row.first);
    }
  }

  Future<List<Attempt>> dirtyAttempts() async {
    final db = await database;
    final rows = await db.query(table, where: 'dirty = 1');
    return rows.map(Attempt.fromMap).toList();
  }

  Future<void> markAllClean(Set<String> uuids) async {
    if (uuids.isEmpty) return;
    final db = await database;
    final placeholders = List.filled(uuids.length, '?').join(',');
    await db.update(
      table,
      {'dirty': 0},
      where: 'uuid IN ($placeholders)',
      whereArgs: uuids.toList(),
    );
  }
}
