import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../src.dart';

/// Database for [Note]s using sqflite_common_ffi
class NotesDatabase {
  static const _databaseName = 'notes.db';
  static const _tableName = 'notes';
  static const _columnColor = 'color';
  static const _columnId = 'id';
  static const _columnTitle = 'title';
  static const _columnText = 'text';

  final Database _db;

  NotesDatabase._(this._db);

  static late final NotesDatabase instance;

  static Future<NotesDatabase> init() async {
    final supportDirectory = await getApplicationSupportDirectory();
    final path = '${supportDirectory.path}/$_databaseName';
    log.i('Database path: $path');

    // open the database
    final database = await databaseFactoryFfi.openDatabase(path);

    // create the table
    await database.execute('''
CREATE TABLE IF NOT EXISTS $_tableName (
  $_columnColor INTEGER NOT NULL,
  $_columnId TEXT PRIMARY KEY,
  $_columnTitle TEXT NOT NULL,
  $_columnText TEXT NOT NULL
)
''');

    instance = NotesDatabase._(database);
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

  Future<List<Note>> getAll() async {
    final maps = await _db.query(_tableName, orderBy: '$_columnId ASC');
    return List.generate(maps.length, (i) {
      return Note.fromJson(maps[i]);
    });
  }
}
