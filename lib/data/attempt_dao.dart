import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/attempt.dart';

class AttemptDao {
  static final AttemptDao _instance = AttemptDao._internal();
  factory AttemptDao() => _instance;
  AttemptDao._internal();

  static const _dbName = 'attempts.db';
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
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uuid TEXT NOT NULL UNIQUE,
            studentId TEXT NOT NULL,
            data TEXT NOT NULL,
            updatedAt TEXT NOT NULL,
            dirty INTEGER NOT NULL DEFAULT 1
          )
        ''');
      },
    );

    return _db!;
  }

  // ===============================================================
  //  INSERT OR UPDATE (UPSERT)
  // ===============================================================

  Future<Attempt> upsert(Attempt attempt) async {
    final db = await database;

    final map = attempt.toMap()..remove('id'); // SQLite controls id

    final existing = await db.query(
      table,
      where: 'uuid = ?',
      whereArgs: [attempt.uuid],
      limit: 1,
    );

    if (existing.isEmpty) {
      final id = await db.insert(
        table,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return attempt.copyWith(id: id);
    } else {
      await db.update(
        table,
        map,
        where: 'uuid = ?',
        whereArgs: [attempt.uuid],
      );

      final row = await db.query(
        table,
        where: 'uuid = ?',
        whereArgs: [attempt.uuid],
        limit: 1,
      );

      return Attempt.fromMap(row.first);
    }
  }

  // ===============================================================
  //  QUERY ALL ATTEMPTS
  // ===============================================================

  Future<List<Attempt>> getAll() async {
    final db = await database;
    final rows = await db.query(
      table,
      orderBy: 'updatedAt DESC',
    );
    return rows.map((e) => Attempt.fromMap(e)).toList();
  }

  // ===============================================================
  //  QUERY DIRTY ATTEMPTS (NEED SYNC)
  // ===============================================================

  Future<List<Attempt>> dirtyAttempts() async {
    final db = await database;
    final rows = await db.query(
      table,
      where: 'dirty = 1',
    );
    return rows.map((e) => Attempt.fromMap(e)).toList();
  }

  // ===============================================================
  //  MARK ATTEMPTS CLEAN AFTER SYNC
  // ===============================================================

  Future<void> markClean(Set<String> uuids) async {
    if (uuids.isEmpty) return;
    final db = await database;

    final qMarks = List.filled(uuids.length, '?').join(',');

    await db.update(
      table,
      {'dirty': 0},
      where: 'uuid IN ($qMarks)',
      whereArgs: uuids.toList(),
    );
  }

  // ===============================================================
  //  DELETE ATTEMPT
  // ===============================================================

  Future<void> delete(String uuid) async {
    final db = await database;
    await db.delete(
      table,
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
  }
}
