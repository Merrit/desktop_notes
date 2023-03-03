import 'dart:io';

import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../src.dart';
import 'helpers.dart';

/// Database for [Note]s using sqflite_common_ffi
class NotesDatabase {
  static const _databaseName = 'notes.db';
  static const _tableName = 'notes';
  static const _columnColor = 'color';
  static const _columnId = 'id';
  static const _columnIndex = '`index`'; // index is a reserved word
  static const _columnTitle = 'title';
  static const _columnText = 'text';

  final Database _db;

  /// The path to the database file.
  final String databasePath;

  const NotesDatabase._(
    this._db, {
    required this.databasePath,
  });

  static late NotesDatabase instance;

  static Future<NotesDatabase> init() async {
    final supportDirectory = await getSupportDirectory();
    final windowsPath = '${supportDirectory.path}\\database\\$_databaseName';
    final unixPath = '${supportDirectory.path}/database/$_databaseName';
    final path = Platform.isWindows ? windowsPath : unixPath;
    log.i('Database path: $path');

    // open the database
    final database = await databaseFactoryFfi.openDatabase(path);

    // create the table
    await database.execute('''
CREATE TABLE IF NOT EXISTS $_tableName (
  $_columnColor INTEGER NOT NULL,
  $_columnId TEXT PRIMARY KEY,
  $_columnIndex INTEGER NOT NULL,
  $_columnTitle TEXT NOT NULL,
  $_columnText TEXT NOT NULL
)
''');

    instance = NotesDatabase._(
      database,
      databasePath: path,
    );

    return instance;
  }

  Future<void> close() async {
    await _db.close();
  }

  Future<void> delete(Note note) async {
    await _db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteAll() async {
    await _db.delete(_tableName);
  }

  Future<void> save(Note note) async {
    await _db.insert(
      _tableName,
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Save all notes.
  Future<void> saveAll(List<Note> notes) async {
    final batch = _db.batch();
    for (final note in notes) {
      batch.insert(
        _tableName,
        note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<Note>> getAll() async {
    final maps = await _db.query(_tableName, orderBy: '$_columnId ASC');
    return List.generate(maps.length, (i) {
      return Note.fromJson(maps[i]);
    });
  }
}
