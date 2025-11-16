import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

Future<Database> openAppDatabase(String dbName, String tableSql) async {
  // Use in-memory database for web or desktop (anything not Android/iOS)
  if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
    return openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async => await db.execute(tableSql),
    );
  } else {
    // Mobile: use real file-based SQLite
    final path = p.join(await getDatabasesPath(), dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async => await db.execute(tableSql),
    );
  }
}
